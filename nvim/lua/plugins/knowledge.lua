return {
  -- =========================================
  -- 1. INFRASTRUCTURE: Luarocks & Image Engine
  -- =========================================
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = { rocks = { "magick" } },
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
      -- NEW: Timestamp Macro
      {
        "<leader>on",
        function()
          local time = os.date("%H:%M")
          -- Inserts "#### HH:MM - " and switches to Insert Mode
          vim.api.nvim_put({ "#### " .. time .. " - " }, "c", true, true)
          vim.cmd("startinsert!")
        end,
        desc = "Insert Timestamp",
      },
      -- JD Automation Logic
      {
        "<leader>oj",
        function()
          _G.create_jd_note()
        end,
        desc = "New Johnny Decimal Note",
      },
      -- Daily Note with Template
      {
        "<leader>od",
        "<cmd>ObsidianToday<cr>",
        desc = "Today's Daily Note",
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
            local vault_path = vim.fn.expand("~/obsidian/" .. choice)
            vim.cmd("cd " .. vault_path)
            vim.notify("Switched to Vault: " .. choice, vim.log.levels.INFO)
          end)
        end,
        desc = "Switch Workspace",
      },
      -- Standard Keys
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Knowledge" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Switch Note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
      { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste Image" },
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/obsidian/personal",
          overrides = {
            daily_notes = {
              folder = "00-Inbox/02-Daily",
              template = "99.01 - Daily Notes.md",
            },
            templates = {
              subdir = "99-Resources/99-Templates",
              date_format = "%Y-%m-%d",
              time_format = "%H:%M",
            },
          },
        },
        {
          name = "devops",
          path = "~/obsidian/devops",
          overrides = {
            daily_notes = {
              folder = "00-Inbox/02-Daily",
              template = "99.01 - Daily Notes.md",
            },
            templates = {
              subdir = "99-Resources/99-Templates",
              date_format = "%Y-%m-%d",
              time_format = "%H:%M",
            },
          },
        },
      },
      daily_notes = {
        folder = "00-Inbox/02-Daily",
        date_format = "%Y-%m-%d",
        template = "99.01 - Daily Notes.md",
      },
      attachments = {
        img_folder = "00-Inbox/01-Assets",
      },
      templates = {
        subdir = "99-Resources",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      note_id_func = function(title)
        return title or tostring(os.time())
      end,
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- JD Auto-Allocator Logic (Strict Mode)
      _G.create_jd_note = function()
        local obs_client = require("obsidian").get_client()
        local workspace_path = vim.fs.normalize(obs_client.dir.filename)
        local vault_name = obs_client.current_workspace.name
        local scan = require("plenary.scandir")

        -- STRICT Helper: ID is derived ONLY from the folder prefix
        local function create_note_in_category(category_path, category_folder_name)
          local category_id = category_folder_name:match("^(%d%d)") or "00"
          local max_index = 0

          local files = scan.scan_dir(category_path, { depth = 1, search_pattern = "%.md$" })
          for _, file in ipairs(files) do
            local id_match = vim.fn.fnamemodify(file, ":t"):match("^" .. category_id .. "%.(%d+)")
            if id_match then
              max_index = math.max(max_index, tonumber(id_match))
            end
          end

          local subdirs = scan.scan_dir(category_path, { depth = 1, only_dirs = true })
          for _, dir in ipairs(subdirs) do
            local id_match = vim.fn.fnamemodify(dir, ":t"):match("^" .. category_id .. "%.(%d+)")
            if id_match then
              max_index = math.max(max_index, tonumber(id_match))
            end
          end

          local full_id = string.format("%s.%02d", category_id, max_index + 1)

          vim.ui.input({ prompt = "Title (" .. full_id .. "): " }, function(input)
            if not input or input == "" then
              return
            end
            vim.ui.select(
              { "Note (Flat File)", "Project (Folder Bundle)" },
              { prompt = "Select Type:" },
              function(type_choice)
                if not type_choice then
                  return
                end
                local is_folder = type_choice == "Project (Folder Bundle)"
                local name = string.format("%s - %s", full_id, input)
                local path = is_folder and (category_path .. "/" .. name .. "/" .. name .. ".md")
                  or (category_path .. "/" .. name .. ".md")

                if is_folder then
                  vim.fn.mkdir(category_path .. "/" .. name, "p")
                end
                local file = io.open(path, "w")
                if file then
                  file:write(
                    "---\nid: "
                      .. full_id
                      .. "\ntype: "
                      .. (is_folder and "project" or "note")
                      .. "\n---\n\n# "
                      .. input
                      .. "\n\n"
                  )
                  file:close()
                  vim.schedule(function()
                    vim.cmd("edit " .. path)
                  end)
                end
              end
            )
          end)
        end

        local areas = scan.scan_dir(workspace_path, { depth = 1, only_dirs = true })
        local area_options = {}
        for _, dir in ipairs(areas) do
          local name = vim.fn.fnamemodify(dir, ":t")
          -- STRICT: Only add Areas starting with digits (e.g. 10-DevOps)
          if name:match("^%d%d%-") then
            table.insert(area_options, name .. "/")
          end
        end
        table.sort(area_options)

        vim.ui.select(area_options, { prompt = "Select Area [" .. vault_name .. "]:" }, function(area_choice)
          if not area_choice then
            return
          end
          local area_path = workspace_path .. "/" .. area_choice:sub(1, -2)
          local categories = scan.scan_dir(area_path, { depth = 1, only_dirs = true })
          local cat_options = {}
          for _, dir in ipairs(categories) do
            local name = vim.fn.fnamemodify(dir, ":t")
            -- STRICT: Only add Categories starting with digits (e.g. 11-General)
            if name:match("^%d%d%-") then
              table.insert(cat_options, name)
            end
          end

          if #cat_options > 0 then
            table.sort(cat_options)
            vim.ui.select(cat_options, { prompt = "Select Category:" }, function(cat_choice)
              if cat_choice then
                create_note_in_category(area_path .. "/" .. cat_choice, cat_choice)
              end
            end)
          else
            create_note_in_category(area_path, area_choice:sub(1, -2))
          end
        end)
      end
    end,
  },

  -- =========================================
  -- 3. IMAGE TOOLS
  -- =========================================
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    keys = { { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste Image" } },
    opts = {
      default = {
        prompt_for_file_name = true,
        dir_path = "00-Inbox/01-Assets",
      },
    },
  },
}
