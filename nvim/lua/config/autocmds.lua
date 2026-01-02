-- lua/config/autocmds.lua

-- 1. FORCE create the directory immediately on startup
local log_path = vim.fn.expand("~/.local/share/nvim/typing_practice_log")
local log_dir = vim.fn.fnamemodify(log_path, ":h")

-- Force create directory now (synchronously)
if vim.fn.isdirectory(log_dir) == 0 then
  local success = vim.fn.mkdir(log_dir, "p")
  if success then
    print("✅ Created log directory: " .. log_dir)
  else
    print("❌ Failed to create log directory: " .. log_dir)
  end
end

-- 2. The Debug Autocommand
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local bufname = vim.api.nvim_buf_get_name(0)
    -- Print "DEBUG" message for EVERYTHING you close
    print("🔍 DEBUG: Closing window. Filetype: '" .. ft .. "' | Name: '" .. bufname .. "'")

    -- Logic to update log
    if ft == "speedtyper" or string.match(bufname, "VimBeGood") then
      os.execute("touch " .. log_path)
      print("✅ MATCH FOUND! Log updated.")
    end
  end,
})
