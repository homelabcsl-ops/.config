-- lua/config/autocmds.lua

-- 1. LOUD STARTUP CHECK
-- This will show a popup immediately when you restart Neovim.
-- If you don't see this, the file isn't being read.
vim.notify("✅ DIAGNOSTIC: Autocmds file is loaded!", vim.log.levels.WARN)

-- Define log file path
local practice_log = vim.fn.expand("~/.local/share/nvim/typing_practice_log")

-- 2. Ensure directory exists (Silent fix)
local log_dir = vim.fn.fnamemodify(practice_log, ":h")
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

-- 3. Watch for Window Closing
vim.api.nvim_create_autocmd("WinClosed", {
  pattern = "*",
  callback = function(args)
    local win_id = tonumber(args.match)

    -- Safely get buffer info
    local status, buf_id = pcall(vim.api.nvim_win_get_buf, win_id)
    if not status then
      return
    end

    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
    local buf_name = vim.api.nvim_buf_get_name(buf_id)

    -- DEBUG: Uncomment the line below to see EVERY window you close
    -- vim.notify("Closing: " .. ft, vim.log.levels.INFO)

    -- Check for tools
    if ft == "speedtyper" or string.match(buf_name, "VimBeGood") then
      -- Update file timestamp
      os.execute("touch " .. practice_log)
      -- LOUD SUCCESS MESSAGE
      vim.notify("✅ DRILL COMPLETE: Logged to file.", vim.log.levels.WARN)
    end
  end,
})
