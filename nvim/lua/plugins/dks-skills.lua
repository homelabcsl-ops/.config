return {
  -- SERVICE 1: VimBeGood (Precision Training)
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    keys = {
      -- FIX: Remapped to <leader>kv to avoid conflict with Grep (<leader>kg)
      { "<leader>kv", "<cmd>VimBeGood<cr>", desc = "Skill: Precision (VimBeGood)" },
    },
  },

  -- SERVICE 2: Terminal Skills (Replaces Speedtyper)
  -- Uses `folke/snacks` to launch your system binaries in a floating terminal
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>kt",
        function()
          Snacks.terminal("ttyper")
        end,
        desc = "Skill: Code Syntax (Ttyper)",
      },
      -- Reusing <leader>ks key for Gtypist to avoid <leader>kg conflict
      {
        "<leader>ks",
        function()
          Snacks.terminal("gtypist")
        end,
        desc = "Skill: Touch Typing (Gtypist)",
      },
    },
    opts = function(_, opts)
      -- 1. DEFINE YOUR VAULT PATH
      local vault_path = vim.fn.expand("~/obsidian/devops")
      local obs_folder = vault_path .. "/10-DevOps-Lab/18-Observability"
      local metric_file = obs_folder .. "/18.01 - metrics.md"

      -- 2. CREATE THE LOGGING COMMAND
      vim.api.nvim_create_user_command("LogSkill", function()
        -- Prompt the user for the score using the Snacks UI
        -- Updated prompt example to match new tools
        vim.ui.input({ prompt = "Enter Skill Metric (e.g., 'Ttyper: 98% acc'): " }, function(input)
          if input and input ~= "" then
            -- Safety: Ensure directory exists
            vim.fn.mkdir(obs_folder, "p")

            -- Create the timestamp
            local date = os.date("%Y-%m-%d %H:%M:%S")
            -- Format for Markdown Table
            local log_entry = string.format("| %s | Manual | %s | - |", date, input)

            -- Write to the file
            local file = io.open(metric_file, "a")
            if file then
              file:write(log_entry .. "\n")
              file:close()
              vim.notify("✓ Metric logged to DKS", vim.log.levels.INFO)
            else
              vim.notify("⚠ ERROR: Could not find " .. metric_file .. ". Check your path.", vim.log.levels.ERROR)
            end
          end
        end)
      end, { desc = "Log skill metrics to Obsidian" })
      return opts
    end,
  },
}
