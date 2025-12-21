vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin:/usr/local/bin"

-- Safe Global Variable
_G.DKS_STATUS = "󰻠 CPU: -- | 󱠔 K8S: Init"

local function update_telemetry()
  -- Automatically finds the script inside your nvim config
  local script_path = vim.fn.stdpath("config") .. "/scripts/telem.sh"

  -- Safety check: Only execute if the file exists and is executable
  if vim.fn.executable(script_path) == 1 then
    vim.fn.jobstart(script_path, {
      on_stdout = function(_, data)
        if data and data[1] ~= "" then
          _G.DKS_STATUS = data[1]
          -- Refresh dashboard UI safely
          pcall(function()
            require("snacks").dashboard.update()
          end)
        end
      end,
    })
  end
end

-- Timer using modern Neovim API
local uv = vim.uv or vim.loop
local timer = uv.new_timer()
if timer then
  timer:start(0, 10000, vim.schedule_wrap(update_telemetry))
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          -- PASSING RAW STRING: This prevents the 'resolve' nil crash
          { section = "text", text = _G.DKS_STATUS, hl = "SnacksDashboardDesc", padding = 1 },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
