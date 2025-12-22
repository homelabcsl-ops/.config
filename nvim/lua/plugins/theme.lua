return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local is_muted = true

      local muted_palette = {
        bg = "#161617",
        bg_dark = "#0f0f10",
        bg_highlight = "#232326",
        border = "#27272a",
        fg = "#c1c1c1",
        fg_gutter = "#43444f",
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

              colors.blue = "#7aa2f7"
              colors.green = "#98bb6c"
              colors.magenta = "#bb9af7"
              colors.orange = "#e0af68"
              colors.red = "#e67e80"
              colors.comment = "#565f89"
            else
              colors.bg = "#1a1b26"
              colors.fg = "#ffffff"
              colors.blue = "#2ac3de"
            end
          end,

          on_highlights = function(hl, c)
            -- FIX: 'c' is now used to ensure UI elements match the active theme's colors
            hl.FloatBorder = { fg = muted_palette.border, bg = c.bg_dark }
            hl.NormalFloat = { bg = c.bg_dark }
            hl.CursorLine = { bg = muted_palette.bg_highlight }

            -- Obsidian/Markdown Hierarchy (Using fixed muted hexes for specific look)
            hl["@text.title.1.markdown"] = { fg = c.blue, bold = true } -- Uses c.blue from on_colors
            hl["@text.title.2.markdown"] = { fg = c.green, bold = true } -- Uses c.green from on_colors
            hl["@text.title.3.markdown"] = { fg = c.magenta } -- Uses c.magenta
            hl["@text.reference.markdown"] = { fg = c.orange } -- Uses c.orange
            hl["@text.uri.markdown"] = { fg = c.cyan, underline = true } -- Uses c.cyan

            -- Code Blocks (Uses c.bg_dark for consistent depth)
            hl.MarkdownCode = { bg = c.bg_dark }
            hl.MarkdownCodeDelimiter = { fg = muted_palette.fg_gutter }
          end,
        })
        vim.cmd([[colorscheme tokyonight]])
      end

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

      apply_theme("muted")
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Muted Theme" })
    end,
  },
}
