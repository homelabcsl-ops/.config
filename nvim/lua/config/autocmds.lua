-- lua/config/autocmds.lua

vim.notify("✅ DIAGNOSTIC: Autocmds loaded!", vim.log.levels.WARN)

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

    -- Get both Filetype and Name, convert to lowercase for easy matching
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id }):lower()
    local buf_name = vim.api.nvim_buf_get_name(buf_id):lower()

    -- DEBUG: This tells us exactly what VimBeGood is calling itself if it fails again
    -- vim.notify("Closed: FT=['" .. ft .. "'] Name=['" .. buf_name .. "']", vim.log.levels.INFO)

    -- The "Broad Net" Check
    if ft == "speedtyper" or buf_name:match("vimbegood") or buf_name:match("vim-be-good") or ft:match("vimbegood") then
      os.execute("touch " .. practice_log)
      vim.notify("✅ DRILL COMPLETE: Logged successfully.", vim.log.levels.WARN)
    end
  end,
})
