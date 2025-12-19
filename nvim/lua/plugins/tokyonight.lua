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
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_popup = bg_dark
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_search = bg_search
          colors.bg_visual = bg_visual
          colors.bg_highlight = bg_highlight
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_sidebar = fg_dark
          colors.fg_gutter = fg_gutter

          -- 2. Apply Boutique Warmth Syntax Colors
          colors.blue = "#e0af68" -- Variables (Gold)
          colors.cyan = "#90bf60" -- Operators (Olive)
          colors.green = "#98c379" -- Strings (Sage Green)
          colors.magenta = "#d19a66" -- Keywords (Soft Orange)
          colors.orange = "#ff9e64" -- Constants (Burnt Orange)
          colors.purple = "#e5c07b" -- Functions (Mustard)
          colors.red = "#e06c75" -- Errors (Soft Red)
        end,
      })

      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
