-- 1. GLOBAL LOGGING FUNCTION
_G.dks_log_skill = function(tool_name)
  local vault_path = vim.fn.expand("~/obsidian/devops")
  local obs_folder = vault_path .. "/10-DevOps-Lab/18-Observability"
  local metric_file = obs_folder .. "/18.01 - metrics.md"

  -- Force Normal mode to ensure we aren't stuck in Terminal/Insert mode
  vim.cmd("stopinsert")

  vim.ui.input({ prompt = "Enter " .. tool_name .. " Result (e.g. '98% / 60wpm'): " }, function(input)
    if input and input ~= "" then
      if vim.fn.isdirectory(obs_folder) == 0 then
        vim.fn.mkdir(obs_folder, "p")
      end

      local date = os.date("%Y-%m-%d %H:%M:%S")
      local log_entry = string.format("| %s | %s | %s | - |", date, tool_name, input)

      local file = io.open(metric_file, "a")
      if file then
        file:write(log_entry .. "\n")
        file:close()
        vim.notify("✓ Saved to 18.01 - metrics.md", vim.log.levels.INFO)
      else
        vim.notify("⚠ ERROR: Could not write to " .. metric_file, vim.log.levels.ERROR)
      end
    end
  end)
end

return {
  -- SERVICE 1: VimBeGood (Precision Training)
  {
    "ThePrimeagen/vim-be-good",
    keys = {
      {
        "<leader>kv",
        function()
          vim.cmd("VimBeGood")
          vim.api.nvim_create_autocmd("BufWinLeave", {
            pattern = "*",
            once = true,
            callback = function()
              if vim.bo.filetype == "vimbegood" or vim.bo.filetype == "" then
                -- Small delay for VimBeGood too, just to be safe
                vim.defer_fn(function()
                  _G.dks_log_skill("VimBeGood")
                end, 100)
              end
            end,
          })
        end,
        desc = "Skill: Precision (VimBeGood)",
      },
    },
  },

  -- SERVICE 2: Terminal Skills (Ttyper & Gtypist)
  {
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "term://*",
        callback = function(args)
          local buf_name = vim.api.nvim_buf_get_name(args.buf)

          if string.find(buf_name, "ttyper") then
            pcall(vim.api.nvim_win_close, 0, true)
            -- FIXED: Added 100ms delay to allow keyboard focus to reset
            vim.defer_fn(function()
              _G.dks_log_skill("Ttyper")
            end, 100)
          elseif string.find(buf_name, "gtypist") then
            pcall(vim.api.nvim_win_close, 0, true)
            -- FIXED: Added 100ms delay
            vim.defer_fn(function()
              _G.dks_log_skill("Gtypist")
            end, 100)
          end
        end,
      })
    end,
    keys = {
      {
        "<leader>kt",
        function()
          Snacks.terminal("ttyper")
        end,
        desc = "Skill: Code Syntax (Ttyper)",
      },
      {
        "<leader>ks",
        function()
          Snacks.terminal("gtypist")
        end,
        desc = "Skill: Touch Typing (Gtypist)",
      },
    },
    opts = function(_, opts)
      vim.api.nvim_create_user_command("LogSkill", function(args)
        local tool = args.args ~= "" and args.args or "Manual Entry"
        _G.dks_log_skill(tool)
      end, { nargs = "?", desc = "Manually log a skill metric to Obsidian" })
      return opts
    end,
  },
}
