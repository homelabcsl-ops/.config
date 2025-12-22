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
          {
            section = "text",
            padding = 1,
            -- Initial state to prevent nil resolve errors
            text = "󰻠 CPU: -- | 󰍛 MEM: ACTIVE | DKS: INITIALIZING",
            hl = "SnacksDashboardDesc",
            init = function(self)
              local uv = vim.uv or vim.loop
              local timer = uv.new_timer()

              -- PROFESSIONAL FIX: Explicit nil check for resource allocation
              if timer then
                timer:start(
                  0,
                  5000,
                  vim.schedule_wrap(function()
                    -- Prevent memory leaks: stop timer if dashboard buffer is closed
                    if not vim.api.nvim_buf_is_valid(self.buf) then
                      if timer:is_active() then
                        timer:stop()
                        timer:close()
                      end
                      return
                    end

                    -- Mac-native telemetry fetch
                    local handle = io.popen("sysctl -n vm.loadavg | awk '{print $2}'")
                    if handle then
                      local cpu = handle:read("*all"):gsub("%s+", "")
                      handle:close()

                      -- Update dashboard state without blocking the UI thread
                      self.text = string.format("󰻠 CPU: %s | 󰍛 MEM: ACTIVE | DKS: LIVE", cpu)
                      pcall(function()
                        self:update()
                      end)
                    end
                  end)
                )
              end
            end,
          },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
