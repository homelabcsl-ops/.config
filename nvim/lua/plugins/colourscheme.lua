return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        dim_nc_background = true, -- Dim inactive windows

        highlight_groups = {
          -- Force your specific greys
          Normal = { bg = "#161617", fg = "#c1c1c1" },
          StatusLine = { bg = "#0f0f10", fg = "#787c99" },

          -- Dashboard specific
          SnacksDashboardHeader = { fg = "love" }, -- Red/Pink mute
          SnacksDashboardDesc = { fg = "text" },
        },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
