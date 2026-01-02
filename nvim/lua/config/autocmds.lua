-- lua/config/autocmds.lua

local practice_log = vim.fn.expand("~/.local/share/nvim/typing_practice_log")

-- 1. Ensure the directory exists (Automated setup)
local log_dir = vim.fn.fnamemodify(practice_log, ":h")
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

-- 2. The Logger Function
local function log_practice(tool_name)
  os.execute("touch " .. practice_log)
  local time = os.date("%H:%M:%S")
  print("✅ " .. tool_name .. " session logged at " .. time)
end

-- 3. The Listener (Updated to catch Floating Windows)
vim.api.nvim_create_autocmd("WinClosed", {
  pattern = "*",
  callback = function(args)
    -- Get the window ID that is closing
    local win_id = tonumber(args.match)

    -- Try to get buffer info (safely)
    local status, buf_id = pcall(vim.api.nvim_win_get_buf, win_id)
    if not status then
      return
    end

    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
    local buf_name = vim.api.nvim_buf_get_name(buf_id)

    -- Check if it matches our tools
    if ft == "speedtyper" then
      log_practice("Speedtyper")
    elseif string.match(buf_name, "VimBeGood") then
      log_practice("Vim-Be-Good")
    end
  end,
})
