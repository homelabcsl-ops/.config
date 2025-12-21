-- File: ~/.config/nvim/lua/plugins/dashboard.lua

local function get_system_stats()
  -- Mac-compatible Telemetry: sysctl for CPU, vm_stat for Memory
  local cmd = "sysctl -n vm.loadavg | awk '{print $2}' && "
    .. "vm_stat | awk '/Pages free/ {free=$3} /Pages active/ {active=$3} END {printf \"%d\", (active+free)*4096/1024/1024}'"

  local handle = io.popen(cmd)
  -- Safety Check for the Handle (Fixes your nil error)
  if not handle then
    return "󰻠 CPU: Error | 󰍛 MEM: Error"
  end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    return "󰻠 CPU: -- | 󰍛 MEM: --"
  end

  local stats = vim.split(vim.trim(result), "\n")
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
