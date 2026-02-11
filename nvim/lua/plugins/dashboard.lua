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
          -- Telemetry: Adjusted TTL to 5s to match your comment
          {
            section = "terminal",
            cmd = "bash ~/.config/nvim/scripts/telem.sh",
            height = 3, -- Increased height to show Training stats
            padding = 1,
            ttl = 5,
            hl = "SnacksDashboardDesc",
          },
          { section = "keys", gap = 1, padding = 1 }, -- Increased gap for readability
          { section = "startup" },
        },
        -- NEW: Specific Training Shortcuts
        keys = {
          {
            icon = "🐧",
            key = "l",
            desc = "LFCS Training (O'Reilly)",
            action = ":e ~/obsidian/dks/training/lfcs/master_log.md",
          },
          {
            icon = "⚡",
            key = "o",
            desc = "Odin Project (Foundations)",
            action = ":e ~/obsidian/dks/training/odin/progress.md",
          },
          {
            icon = "☁️",
            key = "c",
            desc = "Cloud Resume Challenge",
            action = ":cd ~/dev/cloud-resume | :e main.tf",
          },
          { icon = "📝", key = "n", desc = "New DKS Note", action = ":ene | startinsert" },
          { icon = "❌", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
