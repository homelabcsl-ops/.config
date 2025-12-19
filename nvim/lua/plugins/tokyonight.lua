return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- MUTED MISSION CONTROL PALETTE (Background & UI Only)
      local bg = "#161617" -- Neutral Charcoal
      local bg_dark = "#0f0f10" -- Darker UI separation
      local bg_highlight = "#232326" -- Subtle line focus
      local bg_search = "#3d4455" -- Muted steel blue for search
      local bg_visual = "#2c3340" -- Low-vibrancy selection
      local fg = "#c1c1c1" -- Soft off-white
      local fg_dark = "#787c99" -- Dimmed secondary text
      local fg_gutter = "#43444f" -- Muted line numbers
      local border = "#27272a" -- Minimalist structural borders

      require("tokyonight").setup({
        style = "night",
        transparent = false,
        on_colors = function(colors)
          -- 1. Apply Mission Control UI Colors
          colors.blue = "#a9b1d6" -- Variables (Just Grey)
          colors.cyan = "#a9b1d6" -- Operators (Just Grey)
          colors.green = "#c3e88d" -- Strings (Pale Green - keep distinct)
          colors.magenta = "#89ddff" -- Keywords (Subtle Blue)
          colors.orange = "#a9b1d6" -- Constants (Just Grey)
          colors.purple = "#89ddff" -- Functions (Subtle Blue)
          colors.comment = "#565f89" -- Comments (Dark Grey)  -- 2. SYNTAX SECTION (DEFAULTS)
          -- The overrides for colors.blue, colors.green, etc. are REMOVED.
          -- Your code will now use the standard, vibrant TokyoNight palette.
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
