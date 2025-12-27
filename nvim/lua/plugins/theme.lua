return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      local is_deep_ops = true -- Default to "Mocha" (Deep Ops)

      local function apply_theme(flavor)
        require("catppuccin").setup({
          flavour = flavor, -- "mocha" or "frappe"
          transparent_background = false,
          term_colors = true,

          -- "Muted" Integrations
          integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            telescope = true,
            mason = true,
            -- Context awareness for your bottom bar
            lualine = {
              enabled = true,
              options = { theme = "catppuccin" },
            },
          },

          -- Custom Highlights to ensure "Distinct but Muted"
          custom_highlights = function(colors)
            return {
              -- Obsidian / Markdown Hierarchy
              ["@text.title.1.markdown"] = { fg = colors.peach, style = { "bold" } }, -- Distinct Peach
              ["@text.title.2.markdown"] = { fg = colors.mauve, style = { "bold" } }, -- Distinct Mauve
              ["@text.uri.markdown"] = { fg = colors.rosewater, style = { "underline" } },

              -- Comments (Make them truly muted)
              Comment = { fg = colors.overlay0, style = { "italic" } },

              -- Dashboard Headers
              SnacksDashboardHeader = { fg = colors.blue },
            }
          end,
        })

        vim.cmd.colorscheme("catppuccin")
      end

      -- Toggle Logic
      function ToggleMissionControlTheme()
        if is_deep_ops then
          apply_theme("frappe") -- Switch to softer/lighter "Reading" mode
          print("🍦 Mission Control: Soft Mode (Frappe)")
        else
          apply_theme("mocha") -- Switch to deep "Ops" mode
          print("☕ Mission Control: Deep Ops (Mocha)")
        end
        is_deep_ops = not is_deep_ops
      end

      -- Initialize with Mocha (Deep Ops)
      apply_theme("mocha")

      -- Keybinding
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Deep/Soft Theme" })
    end,
  },
}
