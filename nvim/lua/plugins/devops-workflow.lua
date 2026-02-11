return {
  -- 1. Register the key group name
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>k", group = "devops-system", icon = "⚡" },
        { "<leader>a", group = "ai-system", icon = "🤖" },
        { "<leader>w", group = "web-dev", icon = "🌍" }, -- [NEW] Web Group
      },
    },
  },

  -- 2. The DevOps Custom Workflow Logic
  {
    "devops-knowledge-system",
    dir = vim.fn.stdpath("config"),
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- ... (Keep your existing Setup, Vault Path, and Templates here) ...
      local vault_path = vim.fn.expand("~/obsidian/devops")
      local daily_folder = "00-Inbox/Daily"
      local incident_folder = "10-DevOps-Lab/18-Observability/Incidents"

      -- [Existing Templates Block...]
      local templates = {
        daily = { "# %s", "", "## 🎯 Focus for Today", "- [ ] ", "", "## 📝 Engineering Log", "- %s - ", "" },
        incident = { "---", "tags: [incident]", "date: %s", "---", "", "# Post-Mortem: %s", "" },
      }

      -- --- [EXISTING LOGIC: OpenDailyNote & CreateIncidentReport] ---
      _G.OpenDailyNote = function()
        -- ... (Keep existing daily logic) ...
        local date_str = os.date("%Y-%m-%d")
        local file_path = string.format("%s/%s/%s.md", vault_path, daily_folder, date_str)
        vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")
        vim.cmd("edit " .. file_path)
      end

      _G.CreateIncidentReport = function()
        -- ... (Keep existing incident logic) ...
      end

      -- --- [NEW LOGIC: LIVE SERVER CONTROLLER] ---
      _G.ToggleLiveServer = function()
        -- Check if live-server is already running (simple grep check)
        local handle = io.popen("pgrep -f live-server")
        local result = handle:read("*a")
        handle:close()

        if result ~= "" then
          print("🛑 Stopping Live Server...")
          os.execute("pkill -f live-server")
        else
          print("🚀 Starting Live Server...")
          -- Runs in background, opens default browser, ignores cache
          vim.cmd("!live-server . --quiet --no-browser &")
          -- Note: Removed --no-browser if you WANT it to popup automatically.
          -- If you want it to pop up, use: vim.cmd("!live-server . &")
        end
      end
    end,

    -- KEYBINDINGS
    keys = {
      -- ... (Keep existing keys) ...
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

      -- [NEW] WEB DEV KEYS
      {
        "<leader>ws",
        function()
          vim.cmd("!live-server . &")
        end,
        desc = "Start Live Server",
      },
      {
        "<leader>wk",
        function()
          vim.cmd("!pkill -f live-server")
        end,
        desc = "Kill Live Server",
      },
    },
  },
}
