-- lua/plugins/knowledge.lua
-- lua/plugins/knowledge.lua
return {
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
      -- 1. Smart Launch (Existing Fix)
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

      -- 2. NEW: Visual Workspace Switcher (The "Loud" Switch)
      {
        "<leader>ow",
        function()
          -- Define your workspaces here to match opts (for the picker)
          local workspaces = { "devops", "personal" }

          vim.ui.select(workspaces, { prompt = "Select Workspace" }, function(choice)
            if not choice then
              return
            end
            -- A. Switch Obsidian Logic
            vim.cmd("ObsidianWorkspace " .. choice)

            -- B. Switch Neovim Directory (The Visual Feedback)
            local vault_path = vim.fn.expand("~/obsidian/" .. choice)
            vim.cmd("cd " .. vault_path)

            -- C. Notify
            vim.notify("Moved to Vault: " .. choice .. "\nPath: " .. vault_path, vim.log.levels.INFO)
          end)
        end,
        desc = "Switch Workspace",
      },

      {
        "<leader>oj",
        function()
          _G.create_jd_note()
        end,
        desc = "New Johnny Decimal Note",
      },

      -- 3. Standard Keys
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Knowledge" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Switch Note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show Backlinks" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
      { "<leader>oe", "<cmd>ObsidianExtract<cr>", desc = "Extract to Note" },
      { "<leader>od", "<cmd>ObsidianTOC<cr>", desc = "Table of Contents" },
    },

    opts = {
      -- 1. WORKSPACES (Strict Array)
      workspaces = {
        {
          name = "devops",
          path = "~/obsidian/devops",
        },
        {
          name = "personal",
          path = "~/obsidian/personal",
        },
      }, -- FIX 1: Correctly closed brace here

      -- 2. GLOBAL SETTINGS (Siblings to workspaces)
      daily_notes = {
        folder = "00-Inbox/Daily",
        date_format = "%Y-%m-%d",
        template = "daily-note.md",
      },

      -- FIX: Configure Image Destination (New Block)
      attachments = {
        img_folder = "Assets", -- Saves images to your Assets folder
      },

      completion = {
        nvim_cmp = false, -- Disabled to fix startup error
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

      -- FIX: Simplified Note ID Function to prevent crashes
      note_id_func = function(spec)
        -- If the title is already formatted (like "10.01 - Title"), use it exactly.
        -- This prevents the "arithmetic on nil" error.
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
      -- UNIVERSAL FIX: Safety check for templates
      local client = require("obsidian").get_client()
      if client then
        ---@diagnostic disable-next-line: undefined-field
        local _ = client.opts.templates and client.opts.templates.subdir or "Templates"
      end

      -- === JOHNNY DECIMAL AUTOMATION LOGIC ===
      _G.create_jd_note = function()
        -- FIX: Renamed variable to 'obs_client' to avoid shadowing warnings
        local obs_client = require("obsidian").get_client()
        local workspace_path = vim.fs.normalize(obs_client.dir.filename)

        -- 1. Get all directories that start with a number (00-99)
        local scan = require("plenary.scandir")
        local dirs = scan.scan_dir(workspace_path, {
          depth = 1,
          only_dirs = true,
          on_insert = function(entry)
            -- Filter only folders matching "10-Name", "20-Name" format
            return entry:match("/%d%d%-")
          end,
        })

        -- Clean up paths to just show folder names for the UI
        local options = {}
        for _, dir in ipairs(dirs) do
          table.insert(options, vim.fn.fnamemodify(dir, ":t"))
        end
        table.sort(options)

        -- 2. Ask User to Select Category
        vim.ui.select(options, { prompt = "Select JD Category:" }, function(choice)
          if not choice then
            return
          end

          local category_path = workspace_path .. "/" .. choice
          local category_id = choice:sub(1, 2) -- Extract "10" from "10-Linux"

          -- 3. Scan for highest index in that folder
          local max_index = 0
          local files = scan.scan_dir(category_path, { depth = 1, search_pattern = "%.md$" })

          for _, file in ipairs(files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            -- Match files like "10.05 - Title.md"
            local id_match = filename:match("^" .. category_id .. "%.(%d+)")
            if id_match then
              local num = tonumber(id_match)
              if num and num > max_index then
                max_index = num
              end
            end
          end

          -- 4. Calculate Next ID
          local next_index = max_index + 1
          local next_id_str = string.format("%02d", next_index) -- e.g., "05"

          -- 5. Ask for Title
          vim.ui.input({ prompt = "Note Title: " .. category_id .. "." .. next_id_str .. " - " }, function(input)
            if not input or input == "" then
              return
            end

            -- 6. Construct the exact filename
            local filename = string.format("%s.%s - %s.md", category_id, next_id_str, input)
            local full_path = category_path .. "/" .. filename

            -- 7. WRITE TO DISK DIRECTLY (Bypass Neovim Buffers)
            local file = io.open(full_path, "w")
            if file then
              file:write("---\n")
              file:write("id: " .. category_id .. "." .. next_id_str .. "\n")
              file:write("aliases: []\n")
              file:write("tags: []\n")
              file:write("---\n\n")
              file:write("# " .. input .. "\n")
              file:close()

              -- 8. Open the File
              vim.schedule(function()
                vim.cmd("edit " .. full_path)
              end)
            else
              vim.notify("Failed to write file: " .. full_path, vim.log.levels.ERROR)
            end
          end)
        end)
      end
    end,
  },
}
