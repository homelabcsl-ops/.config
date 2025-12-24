return {
  -- 1. THE BRAIN (Obsidian.nvim)
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "personal", path = "~/obsidian/personal" },
        { name = "devops", path = "~/obsidian/devops" },
      },
      daily_notes = { folder = "dailies", date_format = "%Y-%m-%d", template = "daily.md" },
      templates = { subdir = "Templates", date_format = "%Y-%m-%d", time_format = "%H:%M" },
      completion = { nvim_cmp = false, min_chars = 2 },
      ui = { enable = false },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },

      -- === PATCHED TEMPLATE PICKER (The Universal Fix) ===
      {
        "<leader>ot",
        function()
          local client = require("obsidian").get_client()

          -- UNIVERSAL FIX: Bypasses "Undefined field subdir" diagnostic
          local templates_subdir = client.opts.templates and client.opts.templates.subdir or "Templates"
          local templates_dir = client.dir / templates_subdir

          -- Safety Check
          if vim.fn.isdirectory(tostring(templates_dir)) ~= 1 then
            vim.notify("Templates folder not found in: " .. tostring(templates_dir), vim.log.levels.ERROR)
            return
          end

          -- Bridge: Snacks Picker -> Obsidian
          require("snacks").picker.files({
            dirs = { tostring(templates_dir) },
            title = "Insert Template",
            confirm = function(picker, item)
              picker:close()
              if item then
                local template_name = vim.fn.fnamemodify(item.file, ":t:r")
                vim.cmd("ObsidianTemplate " .. template_name)
              end
            end,
          })
        end,
        desc = "Insert Template",
      },

      -- === SEARCH & REFACTORING ===
      {
        "<leader>oo",
        function()
          local root = require("obsidian").get_client().dir
          require("snacks").picker.grep({ dirs = { tostring(root) }, title = "Search Vault" })
        end,
        desc = "Search Content",
      },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
    },
  },
}
