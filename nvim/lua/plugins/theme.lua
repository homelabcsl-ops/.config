return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      local is_carbon = true

      -- Configure the suite
      require("nightfox").setup({
        options = {
          -- Compiled for startup speed
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",
          transparent = false,
          terminal_colors = true,
          dim_inactive = false, -- Keep windows distinct
          module_default = true,
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
        palettes = {
          -- Custom tweaks to ensure "Muted but Vibrant"
          carbonfox = {
            bg1 = "#161616", -- Deep Charcoal (Not Pitch Black)
            bg2 = "#232323", -- Lighter Charcoal for UI
            fg1 = "#b6b8bb", -- Foggy Grey Text (Low Strain)
            sel0 = "#2b2b2b", -- Subtle Selection
          },
        },
        groups = {
          all = {
            -- Force the "Teal" accents you liked earlier
            ["@constructor"] = { fg = "palette.cyan" },
            ["@variable.builtin"] = { fg = "palette.red" }, -- Muted Brick Red

            -- Distinct Markdown Headers for Obsidian
            ["@text.title.1.markdown"] = { fg = "palette.blue", style = "bold" },
            ["@text.title.2.markdown"] = { fg = "palette.cyan", style = "bold" },
            ["@text.uri.markdown"] = { fg = "palette.magenta", style = "underline" },

            -- Dashboard Header
            SnacksDashboardHeader = { fg = "palette.cyan" },

            -- Make UI Borders Metallic
            FloatBorder = { fg = "palette.bg3" },
          },
        },
      })

      -- Theme Swapper Logic
      function ToggleMissionControlTheme()
        if is_carbon then
          vim.cmd("colorscheme nordfox") -- Switch to Arctic Muted
          print("❄️ Mission Control: Arctic (Nordfox)")
        else
          vim.cmd("colorscheme carbonfox") -- Switch to Industrial Charcoal
          print("🏭 Mission Control: Carbon (Carbonfox)")
        end
        is_carbon = not is_carbon
      end

      -- Initialize with Carbonfox
      vim.cmd("colorscheme carbonfox")

      -- Keybinding
      vim.keymap.set("n", "<leader>tm", ToggleMissionControlTheme, { desc = "Toggle Carbon/Arctic Theme" })
    end,
  },
}
