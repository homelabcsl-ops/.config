return {
  -- 1. Register the key group name (Fixed for which-key v3)
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>k", group = "devops-system", icon = "⚡" },
        { "<leader>a", group = "ai-system", icon = "🤖" },
      },
    },
  },

  -- 2. The DevOps Custom Workflow Logic
  {
    "devops-knowledge-system",
    dir = vim.fn.stdpath("config"),
    config = function()
      -- --- CONFIGURATION (ALIGNED) ---
      local vault_path = vim.fn.expand("~/obsidian/devops")
      local daily_folder = "00-Inbox/Daily"
      local incident_folder = "10-DevOps-Lab/18-Observability/Incidents"
      -- NEW: Training Paths
      local lfcs_folder = "20-Training/LFCS"
      local odin_folder = "20-Training/Odin"

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
          "tags: [incident, post-mortem, lfs262]",
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
        -- NEW: LFCS Study Template (Sander van Vugt Structure)
        lfcs = {
          "---",
          "tags: [training, lfcs, linux]",
          "date: %s",
          "---",
          "# LFCS Lesson: %s",
          "",
          "## 🧠 Core Concept",
          "",
          "## 💻 The Lab (Break/Fix)",
          "1. **Command:** `%s`",
          "2. **Expected:** ",
          "3. **Reality:** ",
          "",
          "## 📚 Syntax/Flags",
          "- ",
        },
        -- NEW: Odin Project Dev Log
        odin = {
          "---",
          "tags: [training, odin, dev]",
          "date: %s",
          "---",
          "# Odin Dev Log: %s",
          "",
          "## 🚧 Current Component",
          "- ",
          "",
          "## 🐛 Blockers / Solutions",
          "- ",
        },
      }

      -- --- LOGIC ---

      -- 1. Create or Open Today's Daily Log
      _G.OpenDailyNote = function()
        local date_str = os.date("%Y-%m-%d")
        local time_str = os.date("%H:%M")
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

      -- 2. Create Incident Report (Smart ID)
      _G.CreateIncidentReport = function()
        vim.ui.input({ prompt = "Incident Name: " }, function(input)
          if not input or input == "" then
            return
          end
          local category_id = "18"
          local full_dir_path = vault_path .. "/" .. incident_folder
          vim.fn.mkdir(full_dir_path, "p")

          local scan = require("plenary.scandir")
          local max_index = 0
          local files = scan.scan_dir(full_dir_path, { depth = 1, search_pattern = "%.md$" })
          for _, file in ipairs(files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            local id_match = filename:match("^" .. category_id .. "%.(%d+)")
            if id_match then
              local num = tonumber(id_match)
              if num and num > max_index then
                max_index = num
              end
            end
          end

          local next_index = max_index + 1
          local full_id = string.format("%s.%02d", category_id, next_index)
          local filename = string.format("%s - %s.md", full_id, input)
          local file_path = full_dir_path .. "/" .. filename

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
          vim.cmd("normal 8G$")
        end)
      end

      -- 3. NEW: Create LFCS Lesson Note (Smart ID)
      _G.CreateLFCSSession = function()
        vim.ui.input({ prompt = "Lesson Topic (e.g. File Permissions): " }, function(input)
          if not input or input == "" then
            return
          end
          local full_dir_path = vault_path .. "/" .. lfcs_folder
          vim.fn.mkdir(full_dir_path, "p")

          -- Scan for Lesson-XX
          local scan = require("plenary.scandir")
          local max_index = 0
          local files = scan.scan_dir(full_dir_path, { depth = 1, search_pattern = "%.md$" })
          for _, file in ipairs(files) do
            local filename = vim.fn.fnamemodify(file, ":t")
            -- Matches "Lesson-01 - Title.md"
            local id_match = filename:match("^Lesson%-(%d+)")
            if id_match then
              local num = tonumber(id_match)
              if num and num > max_index then
                max_index = num
              end
            end
          end

          local next_index = max_index + 1
          local filename = string.format("Lesson-%02d - %s.md", next_index, input)
          local file_path = full_dir_path .. "/" .. filename

          vim.cmd("edit " .. file_path)
          local date_str = os.date("%Y-%m-%d")
          local content = {}
          for _, line in ipairs(templates.lfcs) do
            local formatted = line:gsub("%%s", date_str, 1)
            if line:find("# LFCS Lesson:") then
              formatted = line:gsub("%%s", input)
            end
            table.insert(content, formatted)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
          vim.cmd("normal G") -- Go to bottom
          vim.cmd("startinsert!")
        end)
      end

      -- 4. NEW: Create Odin Dev Log
      _G.CreateOdinLog = function()
        vim.ui.input({ prompt = "Dev Feature (e.g. Navbar): " }, function(input)
          if not input or input == "" then
            return
          end
          local full_dir_path = vault_path .. "/" .. odin_folder
          vim.fn.mkdir(full_dir_path, "p")

          local date_str = os.date("%Y-%m-%d")
          local filename = string.format("%s - %s.md", date_str, input)
          local file_path = full_dir_path .. "/" .. filename

          vim.cmd("edit " .. file_path)
          local content = {}
          for _, line in ipairs(templates.odin) do
            local formatted = line:gsub("%%s", date_str, 1)
            if line:find("# Odin Dev Log:") then
              formatted = line:gsub("%%s", input)
            end
            table.insert(content, formatted)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
          vim.cmd("normal G")
          vim.cmd("startinsert!")
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
      -- NEW BINDINGS
      {
        "<leader>kl",
        function()
          _G.CreateLFCSSession()
        end,
        desc = "New LFCS Lesson",
      },
      {
        "<leader>ko",
        function()
          _G.CreateOdinLog()
        end,
        desc = "New Odin Log",
      },
      -- Search Tools
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
