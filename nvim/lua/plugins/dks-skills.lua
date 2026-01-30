-- 1. GLOBAL LOGGING FUNCTION
-- Handles the file writing logic centrally to ensure consistency.
_G.dks_log_skill = function(tool_name)
  -- DEFINED PATHS (Mac Mini / Obsidian Structure)
  local vault_path = vim.fn.expand("~/obsidian/devops")
  local obs_folder = vault_path .. "/10-DevOps-Lab/18-Observability"
  local metric_file = obs_folder .. "/18.01 - metrics.md"

  -- Prompt for the score immediately (Frictionless entry)
  vim.ui.input({ prompt = "Enter " .. tool_name .. " Result (e.g. '98% / 60wpm'): " }, function(input)
    if input and input ~= "" then
      -- 1. Ensure the directory exists
      if vim.fn.isdirectory(obs_folder) == 0 then
        vim.fn.mkdir(obs_folder, "p")
      end

      -- 2. Format the Log Entry
      local date = os.date("%Y-%m-%d %H:%M:%S")
      -- Format: | Date | Tool | Score | Notes |
      local log_entry = string.format("| %s | %s | %s | - |", date, tool_name, input)

      -- 3. Append to File
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
          -- Listener for when the VimBeGood buffer closes
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
      -- RE-ADDED: Ttyper with Automation
      {
        "<leader>kt",
        function()
          Snacks.terminal("ttyper", {
            on_close = function()
              vim.schedule(function()
                _G.dks_log_skill("Ttyper")
              end)
            end,
          })
        end,
        desc = "Skill: Code Syntax (Ttyper)",
      },

      -- Gtypist Configuration
      {
        "<leader>ks",
        function()
          Snacks.terminal("gtypist", {
            on_close = function()
              vim.schedule(function()
                _G.dks_log_skill("Gtypist")
              end)
            end,
          })
        end,
        desc = "Skill: Touch Typing (Gtypist)",
      },
    },
    opts = function(_, opts)
      -- Manual Override Command
      vim.api.nvim_create_user_command("LogSkill", function(args)
        local tool = args.args ~= "" and args.args or "Manual Entry"
        _G.dks_log_skill(tool)
      end, { nargs = "?", desc = "Manually log a skill metric to Obsidian" })

      return opts
    end,
  },
}
