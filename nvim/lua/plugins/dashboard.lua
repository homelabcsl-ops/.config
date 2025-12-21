-- File: ~/.config/nvim/lua/plugins/dashboard.lua

local function get_system_stats()
  -- Pulls 1-minute CPU load average and used memory (Mac-specific)
  local handle = io.popen("sysctl -n vm.loadavg | awk '{print $2}' && free -m 2>/dev/null | awk '/Mem:/ {print $3}'")
  local result = handle:read("*a")
  handle:close()

  local stats = vim.split(result, "\n")
  local cpu = stats[1] or "0.00"
  local mem = stats[2] or "N/A"

  return string.format("󰻠 CPU: %s | 󰍛 MEM: %sMB", cpu, mem)
end

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
          -- The Health Telemetry Line
          {
            section = "text",
            text = function()
              return get_system_stats()
            end,
            hl = "SnacksDashboardDesc",
            padding = 1,
          },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
