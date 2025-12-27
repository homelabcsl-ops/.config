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
      -- FIX 2: Smart Launch for New Notes (Prevents "Buffer not modifiable" error)
      {
        "<leader>on",
        function()
          -- 1. Check if the current buffer is locked (Dashboard, Telemetry, etc.)
          local is_locked = not vim.bo.modifiable or vim.bo.readonly

          if is_locked then
            -- Escape the dashboard
            vim.cmd("enew")

            -- CRITICAL FIX: Force the new buffer to be writable.
            -- Dashboards often set window-local options that 'stick' to the new buffer.
            vim.bo.modifiable = true -- Force write access
            vim.bo.readonly = false -- Disable read-only mode
            vim.bo.buftype = "" -- Ensure it is treated as a standard file
          end

          -- 2. Run ObsidianNew in the clean, writable buffer
          vim.schedule(function()
            vim.cmd("ObsidianNew")
          end)
        end,
        desc = "New Note (Knowledge)",
      },
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
