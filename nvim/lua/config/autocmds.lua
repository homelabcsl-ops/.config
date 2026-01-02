-- lua/config/autocmds.lua

local practice_log = vim.fn.expand("~/.local/share/nvim/typing_practice_log")

-- 1. Debug Message on Startup (To prove this file is loaded)
vim.schedule(function()
  print("✅ Automation System Loaded")
end)

-- 2. Watch for Window Closing
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

    -- Check for tools and update log
    if ft == "speedtyper" or string.match(buf_name, "VimBeGood") then
      os.execute("touch " .. practice_log)
      print("✅ Practice session logged to: " .. practice_log)
    end
  end,
})
