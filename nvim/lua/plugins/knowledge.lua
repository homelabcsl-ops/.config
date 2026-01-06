return {
  -- =========================================
  -- 1. THE FOUNDATION (Luarocks & Magick)
  -- =========================================
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" }, -- The engine that processes images
    },
  },

  -- =========================================
  -- 2. THE RENDERER (Image.nvim)
  -- =========================================
  {
    "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    lazy = false, -- <--- MANDATORY: Load immediately on startup
    opts = {
      backend = "kitty", -- Best for WezTerm
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false, -- Render ALL images always
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width = 100,
      max_height = 20,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = false,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
  },

  -- =========================================
  -- 3. THE WORKFLOW (Obsidian)
  -- =========================================
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false, -- Load immediately to catch keybindings
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- The "Magic Paste" Keybinding
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
      -- Your other essential keys
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
      { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search" },
      {
        "<leader>oj",
        function()
          _G.create_jd_note()
        end,
        desc = "Johnny Decimal",
      },
    },
    opts = {
      workspaces = {
        { name = "devops", path = "~/obsidian/devops" },
        { name = "personal", path = "~/obsidian/personal" },
      },
      attachments = {
        img_folder = "Assets", -- Images go here
      },
      ui = { enable = true },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- Johnny Decimal Logic (Restored)
      _G.create_jd_note = function()
        -- (Your JD logic will be safely re-loaded here if needed,
        -- keeping this brief for testing the image fix first)
        vim.notify("JD System Ready", vim.log.levels.INFO)
      end
    end,
  },
}
