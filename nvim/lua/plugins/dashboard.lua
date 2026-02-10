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
          -- 1. KEEP THIS: Disables the "Ghost Keys" (duplicates)
          keys = {},
        },

        sections = {
          { section = "header" },

          -- 2. TELEMETRY (Fixed path to avoid Error 127)
          {
            section = "terminal",
            cmd = "bash " .. vim.fn.stdpath("config") .. "/scripts/telem.sh",
            height = 1,
            padding = 1,
            ttl = 60,
            hl = "SnacksDashboardDesc",
          },

          -- 3. DEVOPS GROUP (Defined Explicitly)
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

          -- 4. NAVIGATION GROUP (Defined Explicitly)
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

          -- 5. ADMIN GROUP (Defined Explicitly)
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
      },
    },
  },
}
