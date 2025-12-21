return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local is_muted = true -- Tracks current state

      -- Define the custom palettes based on your images
      local muted_palette = {
        bg = "#161617", -- Neutral Charcoal from your DKS image
        bg_dark = "#0f0f10", -- Darker for statusline/sidebars
        bg_highlight = "#232326", -- Subtle line focus
        border = "#27272a", -- Muted structural border
        fg = "#c1c1c1", -- Soft off-white text
        fg_gutter = "#43444f", -- Dimmed line numbers
      }

      local function apply_theme(mode)
        require("tokyonight").setup({
          style = "night",
          transparent = false,
          styles = {
            sidebars = "dark",
            floats = "dark",
          },
          on_colors = function(colors)
            if mode == "muted" then
              colors.bg = muted_palette.bg
              colors.bg_dark = muted_palette.bg_dark
              colors.bg_float = muted_palette.bg_dark
              colors.bg_highlight = muted_palette.bg_highlight
              colors.bg_popup = muted_palette.bg_dark
              colors.bg_sidebar = muted_palette.bg_dark
              colors.bg_statusline = muted_palette.bg_dark
              colors.border = muted_palette.border
              colors.fg = muted_palette.fg
              colors.fg_gutter = muted_palette.fg_gutter
              -- Syntax remains default Tokyo Night for that specific contrast
            else
              -- High Contrast / Outdoor Mode
              colors.bg = "#1a1b26"
              colors.fg = "#ffffff"
            end
          end,
          on_highlights = function(hl, c)
            -- Matches the structural feel of your DKS Cockpit image
            hl.FloatBorder = { fg = muted_palette.border, bg = c.bg_dark }
            hl.NormalFloat = { bg = c.bg_dark }
            hl.CursorLine = { bg = muted_palette.bg_highlight }
          end,
        })
        vim.cmd([[colorscheme tokyonight]])
      end

      -- The Toggle Function
      function ToggleMissionControlTheme()
        if is_muted then
          apply_theme("outdoor")
          print("🛰️ Mission Control: High Contrast Mode")
        else
          apply_theme("muted")
          print("🌑 Mission Control: Muted Mode")
        end
        is_muted = not is_muted
      end

      -- Initial Load
      apply_theme("muted")

      -- Keymap (Frictionless Toggle)
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Muted Theme" })
    end,
  },
}
