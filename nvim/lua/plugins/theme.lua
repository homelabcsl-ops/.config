return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      local is_dragon = true -- Default to the darker "Dragon" theme

      local function apply_theme(mode)
        require("kanagawa").setup({
          compile = true, -- Enable compiling for speed
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = false,
          dimInactive = false,
          terminalColors = true,

          -- Dynamic Color Overrides based on Mode
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = "none",
                },
              },
            },
          },

          -- Theme Logic
          overrides = function(colors)
            local theme = colors.theme
            if mode == "dragon" then
              -- MISSION CONTROL: VOID MODE (Deepest Black)
              return {
                NormalFloat = { bg = "#0d0c0c" },
                FloatBorder = { bg = "#0d0c0c", fg = "#333333" },
                Normal = { bg = "#0d0c0c" }, -- Pitch black background
                TelescopeTitle = { fg = theme.ui.special, bold = true },
                TelescopePromptNormal = { bg = "#121212" },
                TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = "#0d0c0c" },

                -- Obsidian/Markdown Specifics (Stealth)
                ["@text.title.1.markdown"] = { fg = "#E6C384", bold = true }, -- Gold
                ["@text.title.2.markdown"] = { fg = "#7AA89F", bold = true }, -- Teal
                ["@text.uri.markdown"] = { fg = "#7FB4CA", underline = true }, -- Muted Blue
              }
            else
              -- MISSION CONTROL: PAPER MODE (Standard Kanagawa Wave)
              return {
                NormalFloat = { bg = "none" },
                FloatBorder = { bg = "none" },
                TelescopeTitle = { fg = theme.ui.special, bold = true },
                TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
              }
            end
          end,
        })

        -- Load the specific palette flavor
        vim.cmd("colorscheme kanagawa-" .. mode)
      end

      -- Toggle Logic
      function ToggleMissionControlTheme()
        if is_dragon then
          apply_theme("wave") -- Switch to softer "Paper" mode
          print("📜 Mission Control: Ink Mode (Wave)")
        else
          apply_theme("dragon") -- Switch to hard "Void" mode
          print("🐉 Mission Control: Void Mode (Dragon)")
        end
        is_dragon = not is_dragon
      end

      -- Initialize with Dragon (Void) Mode
      apply_theme("dragon")

      -- Keybinding
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Ink/Void Theme" })
    end,
  },
}
