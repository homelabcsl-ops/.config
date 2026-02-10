return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        -- 1. HEADER
        preset = {
          header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM 
    STATUS: [PRODUCTION READY]
          ]],
        },

        -- 2. SECTIONS (Horizontal Layout)
        sections = {
          { section = "header" },

          -- Telemetry (Standard Path)
          {
            section = "terminal",
            cmd = "bash " .. vim.fn.stdpath("config") .. "/scripts/telem.sh",
            height = 1,
            padding = 1,
            ttl = 60,
            indent = 3,
          },

          { icon = " ", key = " ", desc = " ", action = ":echo ''", height = 1 },

          -- 3. THE COLUMNS (Pane = 3)
          -- We define the buttons DIRECTLY inside here. No lookups.
          {
            pane = 3,
            sections = {
              -- COLUMN 1: DEVOPS
              {
                { text = "🚀 DevOps", padding = 1, hl = "Title" },
                {
                  section = "keys",
                  gap = 1,
                  padding = 1,
                  keys = {
                    {
                      icon = "🐧",
                      key = "l",
                      desc = "LFCS",
                      action = ":e ~/obsidian/devops/10-DevOps-Lab/11-Linux-Systems/LFCS-Log.md",
                    },
                    {
                      icon = "⚡",
                      key = "o",
                      desc = "Odin",
                      action = ":e ~/obsidian/devops/50-Software-Lab/51-Web-Foundations/Odin-Log.md",
                    },
                    { icon = "☁️", key = "c", desc = "Cloud", action = ":cd ~/dev/cloud-resume | :e main.tf" },
                  },
                },
              },

              -- COLUMN 2: NAVIGATION
              {
                { text = "📂 Nav", padding = 1, hl = "Title" },
                {
                  section = "keys",
                  gap = 1,
                  padding = 1,
                  keys = {
                    { icon = "🔍", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = "📝", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = "✨", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = "⏱️", key = "r", desc = "Recent", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                  },
                },
              },

              -- COLUMN 3: ADMIN
              {
                { text = "🛠️ Admin", padding = 1, hl = "Title" },
                {
                  section = "keys",
                  gap = 1,
                  padding = 1,
                  keys = {
                    {
                      icon = "⚙️",
                      key = "C",
                      desc = "Config",
                      action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = "📦", key = "x", desc = "Extras", action = ":LazyExtras" },
                    { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
                  },
                },
              },
            },
          },

          { section = "startup" },
        },
      },
    },
  },
}
