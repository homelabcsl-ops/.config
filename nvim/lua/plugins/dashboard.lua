-- 1. PREREQUISITE: Keep the PATH line from your image
vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin:/usr/local/bin"

-- 2. SAFE GLOBAL STATE: Prevents the nil crash in 'resolve'
_G.DKS_STATUS = "󰻠 CPU: -- | 󱠔 K8S: Init"

local function update_telemetry()
  local script = vim.fn.stdpath("config") .. "/scripts/telem.sh"

  -- Only execute if the script exists and is executable
  if vim.fn.executable(script) == 1 then
    vim.fn.jobstart(script, {
      on_stdout = function(_, data)
        if data and data[1] ~= "" then
          _G.DKS_STATUS = data[1]
          -- Safely refresh UI
          pcall(function()
            require("snacks").dashboard.update()
          end)
        end
      end,
    })
  end
end

-- 3. FIX: Modern Neovim 0.10+ Timer API (Replaces image_5f1cd4.png)
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
          -- 4. THE FIX: Text now safely returns the verified string
          {
            section = "text",
            text = function()
              return _G.DKS_STATUS
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
