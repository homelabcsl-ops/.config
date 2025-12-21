-- Global state to store telemetry (Frictionless fallback)
_G.DKS_TELEMETRY = {
  cpu = "0.00",
  mem = "Init...",
  k8s = "Pending",
}

-- ASYNC UPDATER: Runs in the background every 10s
local function update_devops_telemetry()
  -- CPU Load
  vim.fn.jobstart("sysctl -n vm.loadavg | awk '{print $2}'", {
    on_stdout = function(_, data)
      if data[1] ~= "" then
        _G.DKS_TELEMETRY.cpu = vim.trim(data[1])
      end
    end,
  })

  -- K8s Context (Crucial for DevOps Professional)
  vim.fn.jobstart("kubectl config current-context", {
    on_stdout = function(_, data)
      if data[1] ~= "" then
        _G.DKS_TELEMETRY.k8s = vim.trim(data[1])
      end
    end,
  })
end

-- Start the background loop
local timer = vim.loop.new_timer()
timer:start(0, 10000, vim.schedule_wrap(update_devops_telemetry))

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
          -- DYNAMIC TELEMETRY LINE: Safe, fast, and never nil.
          {
            section = "text",
            text = function()
              return string.format("󰻠 CPU: %s | 󱠔 K8S: %s", _G.DKS_TELEMETRY.cpu, _G.DKS_TELEMETRY.k8s)
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
