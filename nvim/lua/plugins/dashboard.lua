return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}

      -- 1. THE MASTER KEY DEFINITIONS
      -- We define every button here so the dashboard can find them.
      opts.dashboard.preset.keys = {
        -- DevOps
        lfcs = {
          icon = "🐧",
          key = "l",
          desc = "LFCS",
          action = ":e ~/obsidian/devops/10-DevOps-Lab/11-Linux-Systems/LFCS-Log.md",
        },
        odin = {
          icon = "⚡",
          key = "o",
          desc = "Odin",
          action = ":e ~/obsidian/devops/50-Software-Lab/51-Web-Foundations/Odin-Log.md",
        },
        cloud = { icon = "☁️", key = "c", desc = "Cloud", action = ":cd ~/dev/cloud-resume | :e main.tf" },

        -- Nav
        files = { icon = "🔍", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        new = { icon = "📝", key = "n", desc = "New File", action = ":ene | startinsert" },
        grep = { icon = "✨", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        recent = { icon = "⏱️", key = "r", desc = "Recent", action = ":lua Snacks.dashboard.pick('oldfiles')" },

        -- Admin
        config = {
          icon = "⚙️",
          key = "C",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        lazy = { icon = "💤", key = "z", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
        quit = { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
      }

      -- 2. HEADER
      opts.dashboard.preset.header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM 
    STATUS: [PRODUCTION READY]
      ]]

      -- 3. HORIZONTAL LAYOUT (PANES)
      opts.dashboard.sections = {
        { section = "header" },

        -- Telemetry (Full Width)
        {
          section = "terminal",
          cmd = "bash " .. vim.fn.stdpath("config") .. "/scripts/telem.sh",
          height = 1,
          padding = 1,
          ttl = 60,
          indent = 3,
        },

        { icon = " ", key = " ", desc = " ", action = ":echo ''", height = 1 }, -- Spacer

        -- THE COLUMNS (Pane = 3 means 3 columns side-by-side)
        {
          pane = 3,
          sections = {
            -- COLUMN 1: DEVOPS
            {
              { text = "🚀 DevOps", padding = 1, hl = "Title" },
              { section = "keys", gap = 1, padding = 1, keys = { "lfcs", "odin", "cloud" } },
            },

            -- COLUMN 2: NAVIGATION
            {
              { text = "📂 Nav", padding = 1, hl = "Title" },
              { section = "keys", gap = 1, padding = 1, keys = { "files", "new", "grep", "recent" } },
            },

            -- COLUMN 3: ADMIN
            {
              { text = "🛠️ Admin", padding = 1, hl = "Title" },
              { section = "keys", gap = 1, padding = 1, keys = { "config", "lazy", "quit" } },
            },
          },
        },

        { section = "startup" },
      }

      return opts
    end,
  },
}
