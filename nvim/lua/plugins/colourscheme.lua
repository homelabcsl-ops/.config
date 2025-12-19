return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        color_overrides = {
          mocha = {
            base = "#161617", -- Your Neutral Charcoal
            mantle = "#0f0f10", -- Your Darker UI split
            crust = "#0f0f10",
            text = "#c1c1c1", -- Your Soft off-white
            subtext1 = "#787c99",
            overlay0 = "#43444f", -- Muted line numbers
          },
        },
        highlight_overrides = {
          mocha = function(c)
            return {
              -- Align Dashboard colors
              SnacksDashboardHeader = { fg = c.blue },
              SnacksDashboardIcon = { fg = c.teal },
              SnacksDashboardKey = { fg = c.peach },

              -- Mute the selection/visual mode
              Visual = { bg = "#2c3340" },
            }
          end,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
