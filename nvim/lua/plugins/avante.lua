-- FORCE THE KEY (Bypassing shell issues for immediate success)
vim.env.GEMINI_API_KEY = "AIzaSyAWfEt2w1-f4riHV4qlsi8ZjZe6UIGh6Qo"

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- Always use the latest version
  opts = {
    -- 1. PROVIDER: Switch to Google (Gemini)
    provider = "gemini",
    -- 2. GEMINI SPECIFIC SETTINGS
    google = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-1.5-pro", -- Speed + Efficiency (Frictionless)
      timeout = 30000, -- 30 seconds
      temperature = 0,
      max_tokens = 4096,
    },

    -- 3. BEHAVIOR
    behaviour = {
      auto_suggestions = false, -- Turn off ghost text if you find it distracting
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },
  },

  -- 4. BUILD STEP (Crucial for Avante)
  build = "make",

  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- Support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      -- Make sure render-markdown is loaded
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
