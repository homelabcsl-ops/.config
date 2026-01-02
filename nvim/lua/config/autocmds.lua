-- lua/config/autocmds.lua

-- Define the log path
local practice_log = vim.fn.expand("~/.local/share/nvim/typing_practice_log")

-- Create the directory if it doesn't exist
local log_dir = vim.fn.fnamemodify(practice_log, ":h")
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

-- Function to update the log timestamp
local function log_practice_session()
  os.execute("touch " .. practice_log)
  vim.notify("✅ Drill Complete: Session logged.", vim.log.levels.INFO)
end

-- Autocommand: Triggers when you leave a buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    if ft == "speedtyper" or string.match(vim.api.nvim_buf_get_name(0), "VimBeGood") then
      log_practice_session()
    end
  end,
})
