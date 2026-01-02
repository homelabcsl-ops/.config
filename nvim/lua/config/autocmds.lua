-- lua/config/autocmds.lua

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

    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id }):lower()
    local buf_name = vim.api.nvim_buf_get_name(buf_id):lower()

    -- 1. NOISE FILTER
    if ft == "snacks_notif" or ft == "noice" or ft == "notify" then
      return
    end

    -- 2. IDENTIFY TOOLS
    local is_typr = (ft == "typr")
    local is_vimbegood = false

    if buf_name:match("vimbegood") then
      is_vimbegood = true
    else
      -- Deep check for VimBeGood
      local lines = vim.api.nvim_buf_get_lines(buf_id, 0, 5, false)
      for _, line in ipairs(lines) do
        if line:match("VimBeGood") then
          is_vimbegood = true
          break
        end
      end
    end

    -- 3. LOG IT
    if is_typr or is_vimbegood then
      os.execute("touch " .. practice_log)
      print("✅ Drill Logged: " .. (is_typr and "Typr" or "VimBeGood"))
    end
  end,
})
