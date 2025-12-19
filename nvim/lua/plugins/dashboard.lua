return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      -- 1. Define the layout of your Mission Control
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = "echo '  SYSTEM STATUS: ONLINE\n  WRAPPER:     ACTIVE (v1.6.0)\n  SYNC MODE:   EXTERNAL (NV)\n  INTERFACE:   READY'",
          height = 5,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },

      -- 2. The Visual Assets (The "Look")
      preset = {
        header = [[
    ██████╗ ██╗  ██╗███████╗    ██╗  ██╗   █████╗   ██████╗   ██████╗
    ██╔══██╗██║ ██╔╝██╔════╝    ██║  ██║  ██╔══██╗  ██╔══██╗  ██╔══██╗
    ██║  ██║█████╔╝ ███████╗    ███████║  ███████║  ██████╔╝  ██║  ██║
    ██║  ██║██╔═██╗ ╚════██║    ██╔══██║  ██╔══██║  ██╔══██╗  ██║  ██║
    ██████╔╝██║  ██╗███████║    ██║  ██║  ██║  ██║  ██║  ██║  ██████╔╝
    ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝  ╚═╝  ╚═╝  ╚═╝  ╚═╝  ╚═════╝
          DEVOPS KNOWLEDGE SYSTEM :: VERSION 1.6.0
        ]],

        -- 3. The Control Panel (The "Feel")
        -- Maps directly to your DKS Manual Keybindings
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New Note", action = "<leader>on" },
          { icon = " ", key = "w", desc = "Search Knowledge", action = "<leader>oo" },
          { icon = " ", key = "p", desc = "Active Projects", action = "<leader>op" },
          { icon = " ", key = "g", desc = "LazyGit", action = "<leader>gg" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
