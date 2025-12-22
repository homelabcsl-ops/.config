local function get_system_stats()
  -- Pulls 1-minute CPU load average and used memory (Mac-specific)
  -- Added a safety check for the handle
  local handle = io.popen(
    "sysctl -n vm.loadavg | awk '{print $2}' && vm_stat | grep 'Pages free' | awk '{print $3}' | sed 's/\\.//'"
  )
  if not handle then
    return "󰻠 CPU: N/A | 󰍛 MEM: N/A"
  end

  local result = handle:read("*a")
  handle:close()

  local stats = vim.split(result, "\n")
  local cpu = (stats[1] and stats[1] ~= "") and stats[1] or "0.00"
  -- Mac doesn't have 'free -m', so we provide a fallback for local Mac usage vs remote Linux
  local mem = (stats[2] and stats[2] ~= "") and stats[2] .. "MB" or "Active"

  return string.format("󰻠 CPU: %s | 󰍛 MEM: %s", cpu, mem)
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
          -- FIXED: Using the standard text section format that Snacks expects
          {
            section = "text",
            padding = 1,
            text = {
              { get_system_stats, hl = "SnacksDashboardDesc" },
            },
          },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
