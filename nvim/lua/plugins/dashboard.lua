vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin:/usr/local/bin"

-- File: ~/.config/nvim/lua/plugins/dashboard.lua

-- 1. PRE-DEFINE THE TELEMETRY AS A GLOBAL STRING
-- This ensures the value exists BEFORE the dashboard even looks for it
_G.DKS_TELEM_STR = "󰻠 CPU: -- | 󱠔 K8S: Local"

-- 2. BACKGROUND UPDATER (Non-blocking)
local function refresh_telem()
  -- Using a simpler command to ensure path safety on Mac
  local cmd = "sysctl -n vm.loadavg | awk '{print $2}'"

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        _G.DKS_TELEM_STR = string.format("󰻠 CPU: %s | 󱠔 K8S: ACTIVE", vim.trim(data[1]))
      end
    end,
  })
end

-- Refresh every 10s using the modern uv API
local uv = vim.uv or vim.loop
local timer = uv.new_timer()
if timer then
  timer:start(0, 10000, vim.schedule_wrap(refresh_telem))
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
          -- Ensure keys are in 'preset.keys' to avoid recent API errors
          keys = {
            {
              icon = "󱓞 ",
              key = "n",
              desc = "New Note",
              action = ":lua Snacks.dashboard.pick('files', {cwd='~/obsidian/00-Inbox'})",
            },
            { icon = " ", key = "q", desc = "Ship & Exit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          -- SOLUTION: PASS THE STRING DIRECTLY (No function call here)
          -- This prevents the 'resolve' nil crash on line 488
          {
            section = "text",
            text = _G.DKS_TELEM_STR,
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
