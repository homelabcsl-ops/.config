return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- MUTED MISSION CONTROL PALETTE (Matches the image)
      local bg = "#161617" -- Neutral Charcoal Background
      local bg_dark = "#0f0f10" -- Darker UI separation panes
      local bg_search = "#3d4455" -- Muted steel blue for search
      local bg_visual = "#2c3340" -- Low-vibrancy selection background
      local fg = "#c1c1c1" -- Soft off-white main text
      local fg_dark = "#787c99" -- Dimmed secondary text (paths/comments)
      local border = "#27272a" -- Minimalist structural borders

      require("tokyonight").setup({
        style = "night",
        transparent = false,
        on_colors = function(colors)
          -- Apply the custom palette base
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_popup = bg_dark
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_search = bg_search
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_sidebar = fg_dark

          -- Soften the distinct syntax colors seen in the dashboard
          colors.blue = "#7aa2f7" -- Section Headers ("Control Deck")
          colors.green = "#73daca" -- Status Indicators ("ACTIVE", "READY")
          colors.magenta = "#bb9af7" -- Soft purple accents
          colors.orange = "#e0af68" -- Git Status & Keybindings
          colors.teal = "#73daca" -- Matching green for consistency
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
