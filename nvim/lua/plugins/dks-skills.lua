-- 1. GLOBAL LOGGING FUNCTION
_G.dks_log_skill = function(tool_name)
  local vault_path = vim.fn.expand("~/obsidian/devops")
  local obs_folder = vault_path .. "/10-DevOps-Lab/18-Observability"
  local metric_file = obs_folder .. "/18.01 - metrics.md"

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

-- 2. HELPER: Launch Terminal & Attach Listener
-- This replaces the failed 'on_close' parameter with a native 'TermClose' event.
local function launch_tool(cmd, name)
  -- Open the tool
  Snacks.terminal(cmd, { interactive = true })

  -- Wait a split second to ensure the buffer is active, then attach listener
  vim.schedule(function()
    local term_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_create_autocmd("TermClose", {
      buffer = term_buf,
      once = true,
      callback = function()
        -- 1. Close the terminal window immediately so it doesn't block the view
        -- (Pressing keys might be needed depending on your shell settings,
        -- but this ensures we try to tidy up)
        pcall(vim.api.nvim_win_close, 0, true)

        -- 2. Trigger the log prompt
        vim.schedule(function()
          _G.dks_log_skill(name)
        end)
      end,
    })
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
                vim.schedule(function()
                  _G.dks_log_skill("VimBeGood")
                end)
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
    keys = {
      {
        "<leader>kt",
        function()
          launch_tool("ttyper", "Ttyper")
        end,
        desc = "Skill: Code Syntax (Ttyper)",
      },
      {
        "<leader>ks",
        function()
          launch_tool("gtypist", "Gtypist")
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
