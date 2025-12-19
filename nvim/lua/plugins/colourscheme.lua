return {
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_italic = true

      require("nord").set_colors({
        ["nord0"] = "#161617", -- Force your background
        ["nord1"] = "#0f0f10", -- Darker split
        ["nord3"] = "#43444f", -- Comments/Gutters
      })

      vim.cmd.colorscheme("nord")

      -- Ensure Dashboard Header pops slightly
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#88C0D0" })
    end,
  },
}
