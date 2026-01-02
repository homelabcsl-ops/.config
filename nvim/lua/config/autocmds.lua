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

    -- 1. Get Details
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id }):lower()
    local buf_name = vim.api.nvim_buf_get_name(buf_id):lower()

    -- 2. NOISE FILTER (Crucial Step)
    -- Ignore the notification windows themselves to stop the loop
    if ft == "snacks_notif" or ft == "noice" or ft == "notify" then
      return
    end

    -- 3. CONTENT CHECK (The "Backup" Plan)
    -- If the name is empty, check if the file contains "VimBeGood" text
    local is_vimbegood = false
    if buf_name:match("vimbegood") then
      is_vimbegood = true
    else
      -- Peek at the first 5 lines to see if it looks like the game
      local lines = vim.api.nvim_buf_get_lines(buf_id, 0, 5, false)
      for _, line in ipairs(lines) do
        if line:match("VimBeGood") or line:match("Exiting") then
          is_vimbegood = true
          break
        end
      end
    end

    -- 4. LOG IT
    if ft == "speedtyper" or is_vimbegood then
      os.execute("touch " .. practice_log)
      -- Use 'print' instead of notify to be 100% safe from loops
      print("✅ Drill Logged: " .. (ft == "speedtyper" and "Speedtyper" or "VimBeGood"))
    end
  end,
})
