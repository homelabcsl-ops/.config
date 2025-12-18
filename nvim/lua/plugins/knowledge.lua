return {
  -- 0. FORMATTING ENGINE (Using LazyVim's built-in Conform support if available, or fallback)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        python = { "black" },
        yaml = { "prettier" },
        json = { "prettier" },
        toml = { "taplo" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
      },
    },
  },

  -- 1. SYSTEM DEPENDENCIES
  { "vhyrro/luarocks.nvim", priority = 1001, opts = { rocks = { "magick" } } },

  -- 2. IMAGE RENDERING
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "kitty", -- Ensure you are using Kitty, WezTerm, or Ghostty
      integrations = { markdown = { enabled = true, download_remote_images = true } },
      max_width = 100,
      max_height = 12,
    },
  },

  -- 3. VISUALS
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = { "1 ", "2 ", "3 ", "4 ", "5 ", "6 " } },
      checkbox = { enabled = true },
    },
  },

  -- 3.5. UTILITIES (LazyVim Integration)
  -- Since you are on LazyVim, Snacks is already loaded.
  -- We just configure the keys you requested.
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = true },
      picker = { enabled = true },
    },
    keys = {
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
    },
  },

  -- 4. THE BRAIN (Obsidian.nvim)
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
      mappings = {
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
    },
    keys = {
      -- === CORE WORKFLOW ===
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },

      -- === PATCHED TEMPLATE PICKER (The Fix) ===
      {
        "<leader>ot",
        function()
          local client = require("obsidian").get_client()
          local templates_dir = client.dir / client.opts.templates.subdir

          -- Safety Check
          if vim.fn.isdirectory(tostring(templates_dir)) ~= 1 then
            vim.notify("Templates folder not found in: " .. tostring(templates_dir), vim.log.levels.ERROR)
            return
          end

          -- Manual Bridge: Snacks Picker -> Obsidian
          Snacks.picker.files({
            dirs = { tostring(templates_dir) },
            title = "Insert Template",
            confirm = function(picker, item)
              picker:close()
              if item then
                -- Strip path and extension to get just the name (e.g. "daily")
                local template_name = vim.fn.fnamemodify(item.file, ":t:r")
                vim.cmd("ObsidianTemplate " .. template_name)
              end
            end,
          })
        end,
        desc = "Insert Template",
      },

      -- === REFACTORING ===
      { "<leader>oe", "<cmd>ObsidianExtractNote<cr>", desc = "Extract Selection", mode = "v" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },

      -- === SEARCH (Using Snacks) ===
      {
        "<leader>oo",
        function()
          -- Hardcode search to Vault Root so it works from anywhere
          local root = require("obsidian").get_client().dir
          Snacks.picker.grep({ dirs = { tostring(root) }, title = "Search Vault" })
        end,
        desc = "Search Content",
      },
      {
        "<leader>os",
        function()
          local root = require("obsidian").get_client().dir
          Snacks.picker.files({ dirs = { tostring(root) }, title = "Find Note" })
        end,
        desc = "Quick Switch",
      },
    },
  },
}
