-- lua/plugins/knowledge.lua
return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note (Knowledge)" },
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
      workspaces = {
        {
          name = "devops",
          path = "~/obsidian/devops",
        },
      },

      -- Daily Notes Configuration
      daily_notes = {
        folder = "00-Inbox/Daily",
        date_format = "%Y-%m-%d",
        template = "daily-note.md",
      },

      -- Completion settings
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Interface mappings (inside the Obsidian buffer)
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

      -- Templates Configuration with THE FIX
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

      -- Attach logic to handle specific template paths safely
      ---@param client obsidian.Client
      note_id_func = function(spec)
        -- Custom ID generation (Time-based or Title-based)
        local path = spec.dir / tostring(spec.title)
        return path:name()
      end,

      -- Frontmatter customization
      note_frontmatter_func = function(note)
        -- Add the schema version to all new notes
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional: Custom UI configuration
      ui = {
        enable = true,
        update_debounce = 200,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },

    -- Config function to apply the LuaLS Fix dynamically if needed
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- UNIVERSAL FIX: Example of how to safely reference the subdir if accessing client manually
      -- This block is just for reference/safety in case you extend the config later
      local client = require("obsidian").get_client()
      if client then
        ---@diagnostic disable-next-line: undefined-field
        local _ = client.opts.templates and client.opts.templates.subdir or "Templates"
      end
    end,
  },
}
