return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM 
    STATUS: [PRODUCTION READY]
          ]],
        },
        sections = {
          { section = "header" },

          -- TELEMETRY SECTION (The Engineer's Pulse)
          {
            section = "terminal",
            cmd = "bash ~/.config/nvim/scripts/telem.sh", -- Points to your standard script location
            height = 1,
            padding = 1,
            ttl = 60, -- Refresh every 5 seconds
            indent = 3,
            hl = "SnacksDashboardDesc",
          },

          -- NAVIGATION KEYS (The Frictionless Bridge)
          {
            section = "keys",
            gap = 1,
            padding = 1,
            keys = {
              -- L: LFCS (Mapped to 11-Linux-Systems)
              {
                icon = "🐧",
                key = "l",
                desc = "LFCS Training",
                action = ":e ~/obsidian/devops/10-DevOps-Lab/11-Linux-Systems/LFCS-Log.md",
              },

              -- O: Odin (Mapped to 51-Web-Foundations)
              {
                icon = "⚡",
                key = "o",
                desc = "Odin Project",
                action = ":e ~/obsidian/devops/50-Software-Lab/51-Web-Foundations/Odin-Log.md",
              },

              -- C: Cloud Resume (Codebase)
              {
                icon = "☁️",
                key = "c",
                desc = "Cloud Resume",
                action = ":cd ~/dev/cloud-resume | :e main.tf",
              },

              { icon = "📝", key = "n", desc = "New Note", action = ":ene | startinsert" },
              { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
            },
          },

          { section = "startup" },
        },
      },
    },
  },
}
