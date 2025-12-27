return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local is_matte = true -- Default to "Matte" (Charcoal) mode

      -- Define the Custom Industrial Palette
      local industrial = {
        -- Charcoal & Metal Backgrounds
        charcoal = "#1b1b1b", -- Matte Background
        deep_metal = "#101010", -- Polished Background
        metallic_grey = "#2a2a2e", -- Sidebar / Floats
        lighter_grey = "#3b3b3e", -- Highlights / Selection

        -- The Accent
        neon_teal = "#73daca", -- The primary accent color
        muted_teal = "#2ac3de", -- Secondary accent
      }

      local function apply_theme(mode)
        require("tokyonight").setup({
          style = "moon", -- "moon" is naturally greyer than "storm" or "night"
          transparent = false,
          styles = {
            sidebars = "dark",
            floats = "dark",
          },

          -- 1. OVERRIDE THE COLORS (The "Charcoal" Layer)
          on_colors = function(colors)
            -- Force the background to be neutral charcoal (removing the blue tint)
            if mode == "matte" then
              colors.bg = industrial.charcoal
              colors.bg_dark = industrial.deep_metal
              colors.bg_float = industrial.metallic_grey
              colors.bg_sidebar = industrial.deep_metal
            else
              -- Polished Mode (Higher contrast, deeper blacks)
              colors.bg = industrial.deep_metal
              colors.bg_dark = "#000000"
              colors.bg_float = industrial.charcoal
              colors.bg_sidebar = "#000000"
            end

            -- Force Metallic UI elements
            colors.bg_highlight = industrial.lighter_grey
            colors.bg_popup = industrial.metallic_grey
            colors.bg_statusline = industrial.metallic_grey

            -- Override Borders to be Metallic
            colors.border = industrial.lighter_grey
          end,

          -- 2. OVERRIDE THE HIGHLIGHTS (The "Teal" Layer)
          on_highlights = function(hl, c)
            -- Force Teal Borders and Accents
            hl.TelescopeBorder = { fg = industrial.neon_teal, bg = c.bg_float }
            hl.FloatBorder = { fg = industrial.neon_teal, bg = c.bg_float }
            hl.NeoTreeWinSeparator = { fg = industrial.lighter_grey }

            -- Line Numbers (Metallic Grey)
            hl.LineNr = { fg = industrial.lighter_grey }
            hl.CursorLineNr = { fg = industrial.neon_teal, bold = true }

            -- Git Signs (Keep them distinct but integrated)
            hl.GitSignsAdd = { fg = industrial.neon_teal }
            -- Dashboard Header (Teal)
            hl.SnacksDashboardHeader = { fg = industrial.neon_teal }

            -- Lualine / Statusline hints
            hl.StatusLine = { bg = industrial.metallic_grey, fg = "#a9b1d6" }
          end,
        })

        vim.cmd([[colorscheme tokyonight]])
      end

      -- Toggle Logic
      function ToggleMissionControlTheme()
        if is_matte then
          apply_theme("polished")
          print("⚙️ Mission Control: Polished Metal (Deep)")
        else
          apply_theme("matte")
          print("🛡️ Mission Control: Matte Charcoal (Flat)")
        end
        is_matte = not is_matte
      end

      -- Initialize
      apply_theme("matte")

      -- Keybinding
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Matte/Polished Theme" })
    end,
  },
}
