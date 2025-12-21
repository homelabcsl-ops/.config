-- 1. DEFINE A SAFE FALLBACK
local sys_telemetry = "󰻠 CPU: -- | 󰍛 MEM: --"

-- 2. SILENT BACKGROUND UPDATE
-- This avoids the io.popen crash by running only if the system is ready
local ok, handle = pcall(io.popen, "sysctl -n vm.loadavg | awk '{print $2}'")
if ok and handle then
  local cpu = handle:read("*a")
  handle:close()
  if cpu and cpu ~= "" then
    sys_telemetry = string.format("󰻠 CPU: %s | 󰍛 DKS: LIVE", vim.trim(cpu))
  end
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
          keys = {
            -- Your standard DKS keys here...
            { icon = " ", key = "q", desc = "Ship & Exit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          -- 3. THE FAILSAFE DISPLAY
          -- We pass the pre-verified string, so it can NEVER be nil
          {
            section = "text",
            text = sys_telemetry,
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
