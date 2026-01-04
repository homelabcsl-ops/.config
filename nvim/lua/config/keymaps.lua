-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps her

-- Map <Space>H to Search Help (Telescope)
vim.keymap.set("n", "<leader>H", "<cmd>Telescope help_tags<cr>", { desc = "Search Help" })
