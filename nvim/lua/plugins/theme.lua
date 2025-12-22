return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local is_muted = true -- Global state for the toggle

      -- 1. THE DKS MUTED PALETTE (Based on your system images)
      local muted_palette = {
        bg = "#161617", -- Neutral Charcoal
        bg_dark = "#0f0f10", -- Deep UI elements
        bg_highlight = "#232326", -- Subtle line focus
        border = "#27272a", -- Minimalist structural borders
        fg = "#c1c1c1", -- Soft off-white
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
          -- 2. IMPLEMENTATION: INTEGRATED OVERRIDE
          on_colors = function(colors)
            if mode == "muted" then
              -- UI Elements
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

              -- MATTE SYNTAX (Complementary desaturated pastels)
              colors.blue = "#7aa2f7" -- Functions / Methods
              colors.green = "#98bb6c" -- Strings / K8s values (Sage)
              colors.magenta = "#bb9af7" -- Keywords / Logic (Soft Purple)
              colors.orange = "#e0af68" -- Numbers / Constants (Muted Gold)
              colors.red = "#e67e80" -- Errors / Deletions (Terracotta)
              colors.comment = "#565f89" -- Dimmed Comments
            else
              -- HIGH CONTRAST / OUTDOOR MODE
              colors.bg = "#1a1b26"
              colors.fg = "#ffffff"
              colors.blue = "#2ac3de"
            end
          end,

          -- 3. MUTED MARKDOWN HIGHLIGHTS
          on_highlights = function(hl, c)
            -- Structural UI (Floats, Dashboard)
            hl.FloatBorder = { fg = muted_palette.border, bg = muted_palette.bg_dark }
            hl.NormalFloat = { bg = muted_palette.bg_dark }
            hl.CursorLine = { bg = muted_palette.bg_highlight }

            -- Obsidian/Markdown Hierarchy
            hl["@text.title.1.markdown"] = { fg = "#7aa2f7", bold = true } -- L1 Header
            hl["@text.title.2.markdown"] = { fg = "#98bb6c", bold = true } -- L2 Header
            hl["@text.title.3.markdown"] = { fg = "#bb9af7" } -- L3 Header
            hl["@text.reference.markdown"] = { fg = "#e0af68" } -- [Links]
            hl["@text.uri.markdown"] = { fg = "#7dcfff", underline = true } -- URLs

            -- Code Blocks in Documentation
            hl.MarkdownCode = { bg = "#0f0f10" }
            hl.MarkdownCodeDelimiter = { fg = "#43444f" }
          end,
        })
        vim.cmd([[colorscheme tokyonight]])
      end

      -- THE FRICTIONLESS TOGGLE FUNCTION
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

      -- INITIAL LOAD
      apply_theme("muted")

      -- KEYMAP: <leader>tm (Toggle Muted)
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Muted Theme" })
    end,
  },
}
