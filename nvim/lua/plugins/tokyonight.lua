return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- MUTED MISSION CONTROL PALETTE
      local bg = "#161617" -- Neutral Charcoal (Less "Blue" punch)
      local bg_dark = "#0f0f10" -- Darker for UI separation
      local bg_highlight = "#232326" -- Subtle line focus
      local bg_search = "#3d4455" -- Muted steel blue for search
      local bg_visual = "#2c3340" -- Low-vibrancy selection
      local fg = "#c1c1c1" -- Soft off-white (prevents "ghosting" on black)
      local fg_dark = "#787c99" -- Dimmed secondary text
      local fg_gutter = "#43444f" -- Very muted line numbers
      local border = "#27272a" -- Minimalist structural borders

      require("tokyonight").setup({
        style = "night",
        transparent = false,
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark

          -- Soften the actual syntax colors (Muted but distinct)
          colors.blue = "#7aa2f7" -- Keep logic visible
          colors.green = "#73daca" -- Muted teal for strings
          colors.magenta = "#bb9af7" -- Soft purple for keywords
          colors.orange = "#e0af68" -- Dull gold for constants
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
