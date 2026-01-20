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

  -- SERVICE 2: Speedtyper (Throughput Training)
  {
    "NStefan002/speedtyper.nvim",
    cmd = "Speedtyper",
    branch = "main",
    keys = {
      { "<leader>ks", "<cmd>Speedtyper<cr>", desc = "Skill: Throughput (Speedtyper)" },
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
      -- FIX: Automatic Logging Hook with Directory Safety
      on_finish = function(stats)
        local vault_path = vim.fn.expand("~/obsidian/devops")
        local obs_folder = vault_path .. "/10-DevOps-Lab/18-Observability"
        local metric_file = obs_folder .. "/18.01 - metrics.md"

        -- Safety: Ensure directory exists before writing
        vim.fn.mkdir(obs_folder, "p")

        local date = os.date("%Y-%m-%d %H:%M:%S")
        local wpm = stats.wpm or 0
        local acc = stats.accuracy or 0
        local log_entry = string.format("| %s | Speedtyper | %s WPM | %s%% |", date, wpm, acc)

        local file = io.open(metric_file, "a")
        if file then
          file:write(log_entry .. "\n")
          file:close()
          vim.notify("✓ Speedtyper metrics auto-logged!", vim.log.levels.INFO)
        else
          vim.notify("⚠ ERROR: Could not write to " .. metric_file, vim.log.levels.ERROR)
        end
      end,
    },
    -- FIX: Crash Prevention (Safety Shield)
    config = function(_, opts)
      require("speedtyper").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "speedtyper",
        callback = function(event)
          vim.b[event.buf].snacks_scroll = false
          vim.b[event.buf].snacks_dim = false
          vim.b[event.buf].snacks_animate = false
          vim.b[event.buf].minianimate_disable = true
        end,
      })
    end,
  },

  -- OBSERVABILITY LAYER: Telemetry Bridge
  -- Uses `folke/snacks` (standard in LazyVim) to handle user input
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- 1. DEFINE YOUR VAULT PATH
      local vault_path = vim.fn.expand("~/obsidian/devops")
      local obs_folder = vault_path .. "/10-DevOps-Lab/18-Observability"
      local metric_file = obs_folder .. "/18.01 - metrics.md"

      -- 2. CREATE THE LOGGING COMMAND
      vim.api.nvim_create_user_command("LogSkill", function()
        -- Prompt the user for the score using the Snacks UI
        vim.ui.input({ prompt = "Enter Skill Metric (e.g., 'VimBeGood: 450ms'): " }, function(input)
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
