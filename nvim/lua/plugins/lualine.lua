-- File: ~/.config/nvim/lua/plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local colors = {
        bg = "#161617", -- Matches your uploaded image background
        bg_dark = "#0f0f10", -- Matches the darker sections of the dashboard
        fg = "#c1c1c1", -- Soft off-white text
        border = "#27272a", -- Structural border color
        blue = "#7aa2f7", -- Tokyo Night blue for the mode indicator
        grey = "#43444f", -- Muted separators
      }

      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = " ", right = " " }, -- Clean, no-arrow look
          disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", color = { bg = colors.blue, fg = colors.bg_dark, gui = "bold" } } },
          lualine_b = { { "branch", icon = "" }, "diff" },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", path = 1, color = { fg = colors.fg } },
          },
          lualine_x = {
            {
              function()
                return "DKS v1.6.0"
              end,
              color = { fg = "#787c99" },
            }, -- System Manual Version
            "diagnostics",
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", color = { bg = colors.grey, fg = colors.fg } } },
        },
      }
    end,
  },
}
