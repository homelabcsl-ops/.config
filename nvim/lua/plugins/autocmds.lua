-- ~/.config/nvim/lua/config/autocmds.lua

-- Define the log path
local practice_log = vim.fn.expand("~/.local/share/nvim/typing_practice_log")

-- Create the directory if it doesn't exist (one-time setup)
local log_dir = vim.fn.fnamemodify(practice_log, ":h")
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

-- Function to update the log timestamp
local function log_practice_session()
  os.execute("touch " .. practice_log)
  -- Optional: Print a subtle confirmation message
  vim.notify("✅ Drill Complete: Session logged.", vim.log.levels.INFO)
end

-- Autocommand: Triggers when you leave a buffer (close the window)
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    -- Check if the buffer closing is one of our training tools
    -- 'speedtyper' is the standard filetype for speedtyper.nvim
    -- 'vim-be-good' buffers often don't set a clean filetype, so we check the buffer name too
    if ft == "speedtyper" or string.match(vim.api.nvim_buf_get_name(0), "VimBeGood") then
      log_practice_session()
    end
  end,
})
