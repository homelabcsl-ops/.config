return {
  -- 1. Register the key group name (Fixed for which-key v3)
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>k", group = "devops-system", icon = "⚡" },
      },
    },
  },

  -- 2. The DevOps Custom Workflow Logic
  {
    "devops-knowledge-system",
    dir = vim.fn.stdpath("config"),
    config = function()
      -- --- CONFIGURATION (ALIGNED) ---
      -- We point this to the SAME vault defined in knowledge.lua
      local vault_path = vim.fn.expand("~/obsidian/devops")

      -- We point this to the SAME daily folder defined in knowledge.lua
      local daily_folder = "00-Inbox/Daily"
      -- NEW PATH: Aligned with LF Module 18 (Observability & Incident Response)
      local incident_folder = "10-DevOps-Lab/18-Observability/Incidents"

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
          "tags: [incident, post-mortem, lfs262]", -- Added LF Course Tag
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

        -- Ensure directory exists (Safe: creates path if missing)
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
          -- Move cursor to "Focus for Today" and enter insert mode
          vim.cmd("normal 4G$")
          vim.cmd("startinsert!")
        end
      end

      -- 2. Create Incident Report (JD-Smart Version)
      _G.CreateIncidentReport = function()
        vim.ui.input({ prompt = "Incident Name: " }, function(input)
          if not input or input == "" then
            return
          end

          -- A. CONFIGURATION
          -- We hardcode the Category ID for Observability/Incidents (18)
          local category_id = "18"
          local full_dir_path = vault_path .. "/" .. incident_folder

          -- Ensure directory exists
          vim.fn.mkdir(full_dir_path, "p")

          -- B. SCANNING LOGIC (Find the next ID)
          local scan = require("plenary.scandir")
          local max_index = 0

          -- Scan for existing files starting with "18.xx"
          local files = scan.scan_dir(full_dir_path, { depth = 1, search_pattern = "%.md$" })
          for _, file in ipairs(files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            -- Regex to capture the number part of "18.05"
            local id_match = filename:match("^" .. category_id .. "%.(%d+)")
            if id_match then
              local num = tonumber(id_match)
              if num and num > max_index then
                max_index = num
              end
            end
          end

          -- C. GENERATE NEXT ID
          local next_index = max_index + 1
          local full_id = string.format("%s.%02d", category_id, next_index)

          -- Create Filename: "18.01 - Incident Name.md"
          local filename = string.format("%s - %s.md", full_id, input)
          local file_path = full_dir_path .. "/" .. filename

          -- D. WRITE & OPEN
          vim.cmd("edit " .. file_path)

          local date_str = os.date("%Y-%m-%d")
          local content = {}
          for _, line in ipairs(templates.incident) do
            local formatted = line:gsub("%%s", date_str, 1)
            if line:find("# Post-Mortem:") then
              formatted = line:gsub("%%s", input)
            end
            table.insert(content, formatted)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)

          -- Move cursor to "Root Cause"
          vim.cmd("normal 8G$")
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
