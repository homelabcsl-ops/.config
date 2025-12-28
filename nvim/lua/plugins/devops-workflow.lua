return {
  -- 1. Register the key group name so the menu looks professional
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      if opts.defaults then
        opts.defaults["<leader>k"] = { name = "+devops-system" }
      end
    end,
  },

  -- 2. The DevOps Custom Workflow Logic
  {
    name = "devops-knowledge-system",
    dir = vim.fn.stdpath("config"),
    config = function()
      -- --- CONFIGURATION (ALIGNED) ---
      -- We point this to the SAME vault defined in knowledge.lua
      local vault_path = vim.fn.expand("~/obsidian/devops")

      -- We point this to the SAME daily folder defined in knowledge.lua
      local daily_folder = "00-Inbox/Daily"

      -- TEMPLATES
      local templates = {
        daily = {
          "# %s",
          "",
          "## 🎯 Focus for Today",
          "- [ ] ",
          "",
          "## 📝 Engineering Log",
          "- %s - ",
          "",
        },
        incident = {
          "---",
          "tags: [incident, post-mortem]",
          "date: %s",
          "---",
          "",
          "# Post-Mortem: %s",
          "",
          "**Severity:** High/Medium/Low",
          "**Status:** Investigating",
          "",
          "## Root Cause",
          "",
          "## Resolution",
          "",
          "## Action Items",
          "- [ ] ",
        },
      }

      -- --- LOGIC ---

      -- 1. Create or Open Today's Daily Log (Aligned with Obsidian Vault)
      _G.OpenDailyNote = function()
        local date_str = os.date("%Y-%m-%d")
        local time_str = os.date("%H:%M")
        -- Construct path: ~/obsidian/devops/00-Inbox/Daily/2025-12-27.md
        local file_path = string.format("%s/%s/%s.md", vault_path, daily_folder, date_str)

        vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")
        local is_new = vim.fn.filereadable(file_path) == 0

        vim.cmd("edit " .. file_path)

        if is_new then
          local content = {}
          for _, line in ipairs(templates.daily) do
            local formatted = line:gsub("%%s", date_str, 1)
            if line:find("- %%s -") then
              formatted = line:gsub("%%s", time_str)
            end
            table.insert(content, formatted)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
          vim.cmd("normal 4G$")
          vim.cmd("startinsert!")
        end
      end

      -- 2. Create Incident Report (Saves to Archive/Incidents)
      _G.CreateIncidentReport = function()
        vim.ui.input({ prompt = "Incident Name: " }, function(input)
          if not input or input == "" then
            return
          end

          local safe_name = input:gsub("%s+", "-"):lower()
          local date_str = os.date("%Y-%m-%d")

          -- Saves to ~/obsidian/devops/40_Archives/incidents/...
          local file_path = string.format("%s/40_Archives/incidents/%s-%s.md", vault_path, date_str, safe_name)

          vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")
          vim.cmd("edit " .. file_path)

          local content = {}
          for _, line in ipairs(templates.incident) do
            local formatted = line:gsub("%%s", date_str, 1)
            if line:find("# Post-Mortem:") then
              formatted = line:gsub("%%s", input)
            end
            table.insert(content, formatted)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
        end)
      end
    end,

    -- KEYBINDINGS
    keys = {
      {
        "<leader>kd",
        function()
          _G.OpenDailyNote()
        end,
        desc = "Open Daily Log",
      },
      {
        "<leader>ki",
        function()
          _G.CreateIncidentReport()
        end,
        desc = "New Incident Report",
      },
      {
        "<leader>kf",
        function()
          require("telescope.builtin").find_files({ cwd = "~/obsidian/devops" })
        end,
        desc = "Find in DevOps Vault",
      },
      {
        "<leader>kg",
        function()
          require("telescope.builtin").live_grep({ cwd = "~/obsidian/devops" })
        end,
        desc = "Grep DevOps Vault",
      },
    },
  },
}
