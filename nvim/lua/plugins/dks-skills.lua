return {
  -- SERVICE 1: VimBeGood (Precision Training)
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    keys = {
      { "<leader>sp", "<cmd>VimBeGood<cr>", desc = "Skill: Precision (VimBeGood)" },
    },
  },

  -- SERVICE 2: Speedtyper (Throughput Training)
  {
    "NStefan002/speedtyper.nvim",
    cmd = "Speedtyper",
    branch = "main",
    keys = {
      { "<leader>st", "<cmd>Speedtyper<cr>", desc = "Skill: Throughput (Speedtyper)" },
    },
    opts = {
      game_modes = {
        -- Automate window layout to ensure focus
        window_config = {
          relative = "editor",
          width = 0.6,
          height = 0.6,
          col = 0.2,
          row = 0.2,
          style = "minimal",
          border = "rounded",
        },
      },
    },
  },

  -- OBSERVABILITY LAYER: Telemetry Bridge
  -- Uses `folke/snacks` (standard in LazyVim) to handle user input
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- 1. DEFINE YOUR VAULT PATH
      -- IMPORTANT: Verify this path matches your actual Obsidian folder structure.
      local vault_path = vim.fn.expand("~/obsidian/devops")
      local metric_file = vault_path .. "/observability/metrics.md"

      -- 2. CREATE THE LOGGING COMMAND
      vim.api.nvim_create_user_command("LogSkill", function()
        -- Prompt the user for the score using the Snacks UI
        vim.ui.input({ prompt = "Enter Skill Metric (e.g., 'VimBeGood: 450ms' or 'WPM: 95'): " }, function(input)
          if input and input ~= "" then
            -- Create the timestamp
            local date = os.date("%Y-%m-%d %H:%M:%S")
            -- Format for Markdown Table
            local log_entry = string.format("| %s | %s |", date, input)
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
