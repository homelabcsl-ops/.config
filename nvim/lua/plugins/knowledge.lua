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
      -- FIXED: True Toggle Mechanism
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
      -- Smart Launch
      {
        "<leader>on",
        function()
          local is_locked = not vim.bo.modifiable or vim.bo.readonly
          if is_locked then
            vim.cmd("enew")
            vim.bo.modifiable = true
            vim.bo.readonly = false
            vim.bo.buftype = ""
          end
          vim.schedule(function()
            vim.cmd("ObsidianNew")
          end)
        end,
        desc = "New Note (Knowledge)",
      },
      -- Workspace Switcher
      {
        "<leader>ow",
        function()
          local workspaces = { "devops", "personal" }
          vim.ui.select(workspaces, { prompt = "Select Workspace" }, function(choice)
            if not choice then
              return
            end
            vim.cmd("ObsidianWorkspace " .. choice)
            local vault_path = vim.fn.expand("~/obsidian/" .. choice)
            vim.cmd("cd " .. vault_path)
            vim.notify("Moved to Vault: " .. choice .. "\nPath: " .. vault_path, vim.log.levels.INFO)
          end)
        end,
        desc = "Switch Workspace",
      },
      -- Johnny Decimal Automation
      {
        "<leader>oj",
        function()
          _G.create_jd_note()
        end,
        desc = "New Johnny Decimal Note",
      },
      -- Standard Keys
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Knowledge" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Switch Note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
      -- Note: <leader>oi is handled by image.nvim above.
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show Backlinks" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
      { "<leader>oe", "<cmd>ObsidianExtract<cr>", desc = "Extract to Note" },
      { "<leader>od", "<cmd>ObsidianTOC<cr>", desc = "Table of Contents" },
    },
    opts = {
      workspaces = {
        { name = "devops", path = "~/obsidian/devops" },
        { name = "personal", path = "~/obsidian/personal" },
      },
      daily_notes = {
        folder = "00-Inbox/Daily",
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
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        tags = "",
        substitutions = {
          yesterday = function()
            return os.date("%Y-%m-%d", os.time() - 86400)
          end,
        },
      },
      note_id_func = function(spec)
        if spec.title then
          return spec.title
        end
        return tostring(os.time())
      end,
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
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
      -- Johnny Decimal Logic
      _G.create_jd_note = function()
        local obs_client = require("obsidian").get_client()
        local workspace_path = vim.fs.normalize(obs_client.dir.filename)
        local scan = require("plenary.scandir")

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

        vim.ui.select(options, { prompt = "Select JD Category:" }, function(choice)
          if not choice then
            return
          end
          local category_path = workspace_path .. "/" .. choice
          local category_id = choice:sub(1, 2)
          local max_index = 0
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

          local next_index = max_index + 1
          local next_id_str = string.format("%02d", next_index)

          vim.ui.input({ prompt = "Note Title: " .. category_id .. "." .. next_id_str .. " - " }, function(input)
            if not input or input == "" then
              return
            end
            local filename = string.format("%s.%s - %s.md", category_id, next_id_str, input)
            local full_path = category_path .. "/" .. filename

            local file = io.open(full_path, "w")
            if file then
              file:write(
                "---\nid: "
                  .. category_id
                  .. "."
                  .. next_id_str
                  .. "\naliases: []\ntags: []\n---\n\n# "
                  .. input
                  .. "\n"
              )
              file:close()
              vim.schedule(function()
                vim.cmd("edit " .. full_path)
              end)
            else
              vim.notify("Failed to write file", vim.log.levels.ERROR)
            end
          end)
        end)
      end
    end,
  },

  -- =========================================
  -- 3. IMAGE TOOLS: Pasting Logic
  -- =========================================
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste Image" },
    },
    opts = {
      default = {
        prompt_for_file_name = true,
        embed_image_as_base64 = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = false,
        relative_to_current_file = true,
        dir_path = "Assets",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$FILE_NAME]($FILE_PATH)", -- Standard Markdown for instant render
          download_images = false,
        },
      },
    },
  },
}
