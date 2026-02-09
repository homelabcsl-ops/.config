return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        -- 1. HEADER & PRESET
        preset = {
          header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM 
    STATUS: [PRODUCTION READY]
          ]],
          -- This line prevents the default keys (f, n, q) from appearing
          keys = {},
        },

        -- 2. SECTIONS
        sections = {
          { section = "header" },

          -- TELEMETRY (Updated to find the script automatically)
          {
            section = "terminal",
            cmd = "bash " .. vim.fn.stdpath("config") .. "/scripts/telem.sh",
            height = 1,
            padding = 1,
            ttl = 60,
            hl = "SnacksDashboardDesc",
          },

          -- YOUR KEYS (Defined explicitly here)
          {
            section = "keys",
            gap = 1,
            padding = 1,
            keys = {
              {
                icon = "🐧",
                key = "l",
                desc = "LFCS Training",
                action = ":e ~/obsidian/devops/10-DevOps-Lab/11-Linux-Systems/LFCS-Log.md",
              },
              {
                icon = "⚡",
                key = "o",
                desc = "Odin Project",
                action = ":e ~/obsidian/devops/50-Software-Lab/51-Web-Foundations/Odin-Log.md",
              },
              { icon = "☁️", key = "c", desc = "Cloud Resume", action = ":cd ~/dev/cloud-resume | :e main.tf" },

              -- Standard Navigation Tools
              { icon = "🔍", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = "📝", key = "n", desc = "New File", action = ":ene | startinsert" },
              {
                icon = "⚙️",
                key = "C",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
            },
          },

          { section = "startup" },
        },
      },
    },
  },
}
