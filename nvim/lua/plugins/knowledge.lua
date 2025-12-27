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

      note_id_func = function(spec)
        local path = spec.dir / tostring(spec.title)
        return path:name()
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
    end,
  },
}
