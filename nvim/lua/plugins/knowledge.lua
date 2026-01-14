return {
  -- =========================================
  -- 1. INFRASTRUCTURE: Luarocks & Image Engine
  -- =========================================
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    event = "VeryLazy",
    keys = {
      {
        "<leader>oi",
        function()
          local img = require("image")
          if img.is_enabled() then
            img.disable()
            vim.notify("Images Hidden", vim.log.levels.INFO)
          else
            img.enable()
            vim.notify("Images Visible", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle Images",
      },
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width = 100,
      max_height = 20,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = false,
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
  },

  -- =========================================
  -- 2. KNOWLEDGE BASE: Obsidian.nvim
  -- =========================================
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- JD Automation Logic
      {
        "<leader>oj",
        function()
          _G.create_jd_note()
        end,
        desc = "New Johnny Decimal Note",
      },
      -- Workspace Switcher
      {
        "<leader>ow",
        function()
          local workspaces = { "personal", "devops" }
          vim.ui.select(workspaces, { prompt = "Select Workspace" }, function(choice)
            if not choice then
              return
            end
            vim.cmd("ObsidianWorkspace " .. choice)

            -- Auto-cd to the selected vault for Telescope/Grepping
            local vault_path = vim.fn.expand("~/obsidian/" .. choice)
            vim.cmd("cd " .. vault_path)
            vim.notify("Switched to Vault: " .. choice, vim.log.levels.INFO)
          end)
        end,
        desc = "Switch Workspace",
      },
      -- Standard Keys
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note (Default)" },
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Knowledge" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Switch Note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
      { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste Image" },
    },
    opts = {
      workspaces = {
        { name = "personal", path = "~/obsidian/personal" },
        { name = "devops", path = "~/obsidian/devops" },
      },
      daily_notes = {
        folder = "00-Inbox",
        date_format = "%Y-%m-%d",
        template = "daily-note.md",
      },
      attachments = {
        img_folder = "Assets",
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      templates = {
        subdir = "01-Admin/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      ui = {
        enable = true,
        update_debounce = 200,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- =========================================
      -- THE LOGIC: JD Auto-Allocator v2 (Universal)
      -- =========================================
      _G.create_jd_note = function()
        local obs_client = require("obsidian").get_client()
        local workspace_path = vim.fs.normalize(obs_client.dir.filename)
        local vault_name = obs_client.current_workspace.name -- Gets 'devops' or 'personal'
        local scan = require("plenary.scandir")

        -- 1. Scan for Categories
        local dirs = scan.scan_dir(workspace_path, {
          depth = 1,
          only_dirs = true,
          on_insert = function(entry)
            return entry:match("/%d%d%-")
          end,
        })

        local options = {}
        for _, dir in ipairs(dirs) do
          table.insert(options, vim.fn.fnamemodify(dir, ":t"))
        end
        table.sort(options)

        -- 2. Select Category
        vim.ui.select(options, { prompt = "Select Category [" .. vault_name .. "]:" }, function(choice)
          if not choice then
            return
          end

          local category_path = workspace_path .. "/" .. choice
          local category_id = choice:sub(1, 2)
          local max_index = 0

          -- 3. INTELLIGENT SCAN: Check Files AND Folders for ID collisions
          -- Check Files
          local files = scan.scan_dir(category_path, { depth = 1, search_pattern = "%.md$" })
          for _, file in ipairs(files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            local id_match = filename:match("^" .. category_id .. "%.(%d+)")
            if id_match then
              local num = tonumber(id_match)
              if num and num > max_index then
                max_index = num
              end
            end
          end
          -- Check Sub-folders (Project Bundles)
          local subdirs = scan.scan_dir(category_path, { depth = 1, only_dirs = true })
          for _, dir in ipairs(subdirs) do
            local dirname = vim.fn.fnamemodify(dir, ":t")
            local id_match = dirname:match("^" .. category_id .. "%.(%d+)")
            if id_match then
              local num = tonumber(id_match)
              if num and num > max_index then
                max_index = num
              end
            end
          end

          local next_index = max_index + 1
          local next_id_str = string.format("%02d", next_index)

          -- 4. Prompt for Title
          vim.ui.input({ prompt = "Title (" .. category_id .. "." .. next_id_str .. "): " }, function(input)
            if not input or input == "" then
              return
            end

            -- 5. Prompt for Type: Note or Project Folder?
            vim.ui.select(
              { "Note (Flat File)", "Project (Folder Bundle)" },
              { prompt = "Select Type:" },
              function(type_choice)
                if not type_choice then
                  return
                end

                local is_folder = type_choice == "Project (Folder Bundle)"

                if is_folder then
                  -- OPTION A: Create Sub-folder Bundle
                  local folder_name = string.format("%s.%s - %s", category_id, next_id_str, input)
                  local full_dir_path = category_path .. "/" .. folder_name
                  local index_filename = folder_name .. ".md"
                  local full_file_path = full_dir_path .. "/" .. index_filename

                  vim.fn.mkdir(full_dir_path, "p")

                  local file = io.open(full_file_path, "w")
                  if file then
                    file:write(
                      "---\nid: "
                        .. category_id
                        .. "."
                        .. next_id_str
                        .. "\ntype: project\n---\n\n# "
                        .. input
                        .. "\n\n"
                    )
                    file:close()
                    vim.schedule(function()
                      vim.cmd("edit " .. full_file_path)
                    end)
                  end
                else
                  -- OPTION B: Standard Flat Note
                  local filename = string.format("%s.%s - %s.md", category_id, next_id_str, input)
                  local full_path = category_path .. "/" .. filename
                  local file = io.open(full_path, "w")
                  if file then
                    file:write("---\nid: " .. category_id .. "." .. next_id_str .. "\ntype: note\n---\n\n# " .. input)
                    file:close()
                    vim.schedule(function()
                      vim.cmd("edit " .. full_path)
                    end)
                  end
                end
              end
            )
          end)
        end)
      end
    end,
  },

  -- =========================================
  -- 3. IMAGE TOOLS (Integrated)
  -- =========================================
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    keys = { { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste Image" } },
    opts = {
      default = {
        prompt_for_file_name = true,
        dir_path = "Assets",
      },
    },
  },
}
