return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}

      -- 1. DEFINE YOUR CUSTOM KEYS HERE (The Source of Truth)
      -- The dashboard engine looks here to find what "lfcs" means.
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.keys = {
        -- DevOps Keys
        lfcs = {
          icon = "🐧",
          key = "l",
          desc = "LFCS Training",
          action = ":e ~/obsidian/devops/10-DevOps-Lab/11-Linux-Systems/LFCS-Log.md",
        },
        odin = {
          icon = "⚡",
          key = "o",
          desc = "Odin Project",
          action = ":e ~/obsidian/devops/50-Software-Lab/51-Web-Foundations/Odin-Log.md",
        },
        cloud = { icon = "☁️", key = "c", desc = "Cloud Resume", action = ":cd ~/dev/cloud-resume | :e main.tf" },

        -- Navigation Keys
        files = { icon = "🔍", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        new = { icon = "📝", key = "n", desc = "New File", action = ":ene | startinsert" },
        proj = { icon = "📂", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
        grep = { icon = "✨", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        recent = {
          icon = "⏱️",
          key = "r",
          desc = "Recent Files",
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        session = { icon = "🔙", key = "s", desc = "Restore Session", section = "session" },

        -- Admin Keys
        config = {
          icon = "⚙️",
          key = "C",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        extras = { icon = "📦", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
        lazy = { icon = "💤", key = "z", desc = "Lazy Plugin Mgr", action = ":Lazy", enabled = package.loaded.lazy },
        quit = { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
      }

      -- 2. DEFINE THE HEADER
      opts.dashboard.preset.header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM 
    STATUS: [PRODUCTION READY]
      ]]

      -- 3. DEFINE THE SECTIONS (Reference the keys above)
      opts.dashboard.sections = {
        { section = "header" },

        -- Telemetry
        { section = "terminal", cmd = "bash ~/scripts/telem.sh", height = 1, padding = 1, ttl = 60, indent = 3 },

        -- Group 1: DevOps
        { text = "   🚀 DevOps Workflow", padding = 1, hl = "Title" },
        {
          section = "keys",
          gap = 1,
          padding = 1,
          -- Since we defined them in preset.keys, we can now list them by name
          keys = { "lfcs", "odin", "cloud" },
        },

        -- Group 2: Navigation
        { text = "   📂 Navigation", padding = 1, hl = "Title" },
        {
          section = "keys",
          gap = 1,
          padding = 1,
          keys = { "files", "new", "proj", "grep", "recent", "session" },
        },

        -- Group 3: Admin
        { text = "   🛠️ System Admin", padding = 1, hl = "Title" },
        {
          section = "keys",
          gap = 1,
          padding = 1,
          keys = { "config", "extras", "lazy", "quit" },
        },

        { section = "startup" },
      }

      return opts
    end,
  },
}
