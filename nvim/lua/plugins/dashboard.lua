return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
    🏛️  DEVOPS KNOWLEDGE SYSTEM v1.6.0
    STATUS: [PRODUCTION READY]
          ]],
        },
        sections = {
          { section = "header" },
          -- Use a Terminal section to run your v1.6.0 Telemetry script
          {
            section = "terminal",
            cmd = "bash Users/homelab/.config/nvim/telem.sh", -- Update this path
            height = 1,
            padding = 1,
            ttl = 5, -- Refresh every 5 seconds
            hl = "SnacksDashboardDesc",
          },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
