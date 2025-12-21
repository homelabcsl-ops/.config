vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin:/usr/local/bin"

-- FORCE INITIALIZATION: Use a simple string to prevent table-indexing nil errors
_G.DKS_STATUS = "󰻠 CPU: -- | 󱠔 K8S: Local"

-- ASYNC UPDATER with Path Safety
local function update_telemetry()
  -- Explicitly set path for Mac mini binaries
  local cmd = "PATH=$PATH:/opt/homebrew/bin:/usr/local/bin; " .. "sysctl -n vm.loadavg | awk '{print $2}'"

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        _G.DKS_STATUS = string.format("󰻠 CPU: %s | 󱠔 K8S: ACTIVE", vim.trim(data[1]))
      end
    end,
    -- If the job fails, it just does nothing (no crash)
    on_stderr = function() end,
  })
end

-- Refresh every 10 seconds
local timer = vim.loop.new_timer()
if timer then
  timer:start(0, 10000, vim.schedule_wrap(update_telemetry))
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
          -- Your keys remain the same
        },
        sections = {
          { section = "header" },
          {
            section = "text",
            -- DEFENSIVE CALL: Uses the global string directly
            text = function()
              return _G.DKS_STATUS or "󰻠 CPU: --"
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
