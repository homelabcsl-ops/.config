-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps her

-- Map <Space>H to Search Help (Telescope)
vim.keymap.set("n", "<leader>H", "<cmd>Telescope help_tags<cr>", { desc = "Search Help" })

-- 1. WINDOW NAVIGATION (Matches Aerospace Directionality)
-- We use CTRL to avoid conflict with Aerospace ALT bindings
local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- 2. WINDOW RESIZING (Optional but recommended for coherence)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- 3. SAVE HABIT (Frictionless Save)
-- Maps Ctrl+s to save, common in non-vim apps, useful bridge
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
