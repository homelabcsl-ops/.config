return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      -- Force the deepest, darkest background logic
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "material" -- Softens the white text
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_ui_contrast = "high" -- Better separation for split panes

      vim.cmd.colorscheme("gruvbox-material")

      -- Manual Overrides to match your specific Hex preferences
      -- (Gruvbox configures via autocmds)
      vim.api.nvim_set_hl(0, "Normal", { bg = "#161617" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "#161617" })
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#d3869b" }) -- Soft Purple
    end,
  },
}
