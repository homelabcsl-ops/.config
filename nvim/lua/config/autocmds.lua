-- lua/config/autocmds.lua

vim.notify("✅ DEBUG MODE: Ready to sniff.", vim.log.levels.WARN)

local practice_log = vim.fn.expand("~/.local/share/nvim/typing_practice_log")
local log_dir = vim.fn.fnamemodify(practice_log, ":h")
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

vim.api.nvim_create_autocmd("WinClosed", {
  pattern = "*",
  callback = function(args)
    local win_id = tonumber(args.match)
    local status, buf_id = pcall(vim.api.nvim_win_get_buf, win_id)
    if not status then
      return
    end

    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
    local buf_name = vim.api.nvim_buf_get_name(buf_id)

    -- THE SNIFFER: This will create a RED popup with the exact details
    -- We need to know what 'FT' (Filetype) and 'Name' are for VimBeGood.
    if ft ~= "noice" and ft ~= "notify" then -- Ignore the notification windows themselves
      vim.notify("CLOSED -> FT: [" .. ft .. "] | Name: [" .. buf_name .. "]", vim.log.levels.ERROR)
    end

    -- Existing Logic (Keep this so Speedtyper still works)
    if ft == "speedtyper" then
      os.execute("touch " .. practice_log)
      vim.notify("✅ DRILL COMPLETE", vim.log.levels.INFO)
    end
  end,
})
