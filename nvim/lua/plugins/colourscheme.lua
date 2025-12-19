return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "dragon", -- "dragon" is darker/greyer than "wave"
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none", -- seamless line numbers
              },
            },
          },
        },
        overrides = function(colors)
          local bg_charcoal = "#161617" -- Your preferred background
          return {
            -- Force your Mission Control background
            Normal = { bg = bg_charcoal },
            NormalFloat = { bg = "#0f0f10" },
            NvimTreeNormal = { bg = bg_charcoal },

            -- Mute the Search colors (as requested)
            Search = { fg = "#c1c1c1", bg = "#3d4455" },

            -- Dashboard Specifics
            SnacksDashboardHeader = { fg = "#7aa2f7" }, -- Keep the header distinct
            SnacksDashboardFooter = { fg = "#787c99" },
            SnacksDashboardKey = { fg = "#e0af68" },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
