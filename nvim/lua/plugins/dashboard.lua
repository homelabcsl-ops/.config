return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      -- 1. THE RESET: Explicitly NULLIFY the dashboard to wipe defaults
      opts.dashboard = nil

      -- 2. THE REBUILD: Define the strict "Source of Truth"
      opts.dashboard = {
        preset = {
          header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM 
    STATUS: [PRODUCTION READY]
          ]],
          -- Disable the default key picker to prevent "Ghost Keys"
          keys = nil,
        },

        -- 3. THE LAYOUT: Manually define every pixel on the screen
        sections = {
          { section = "header" },

          -- TELEMETRY
          {
            section = "terminal",
            cmd = "bash ~/scripts/telem.sh",
            height = 1,
            padding = 1,
            ttl = 60,
            indent = 3,
          },

          -- === GROUP 1: DEVOPS WORKFLOW ===
          { text = "   🚀 DevOps Workflow", padding = 1, hl = "Title" },
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
            },
          },

          -- === GROUP 2: NAVIGATION ===
          { text = "   📂 Navigation", padding = 1, hl = "Title" },
          {
            section = "keys",
            gap = 1,
            padding = 1,
            keys = {
              { icon = "🔍", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = "📝", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = "📂", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
              { icon = "✨", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = "⏱️", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = "🔙", key = "s", desc = "Restore Session", section = "session" },
            },
          },

          -- === GROUP 3: SYSTEM ADMIN ===
          { text = "   🛠️ System Admin", padding = 1, hl = "Title" },
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
              { icon = "📦", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "💤", key = "z", desc = "Lazy Plugin Mgr", action = ":Lazy", enabled = package.loaded.lazy },
              { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
            },
          },

          { section = "startup" },
        },
      }

      return opts
    end,
  },
}
