--1. THE TELEMETRY ENGINE (Mac-Specific)
local function get_system_stats()
  -- Using native macOS commands as per your hardware setup
  local cmd = "sysctl -n vm.loadavg | awk '{print $2}' && "
    .. "vm_stat | awk '/Pages free/ {free=$3} /Pages active/ {active=$3} END {printf \"%d\", (active+free)*4096/1024/1024}'"

  local handle = io.popen(cmd)

  -- Essential Nil Check to prevent the "attempt to call a nil value" crash
  if handle == nil then
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

-- 2. THE DASHBOARD CONFIGURATION
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
            -- Knowledge Section (The Brain)
            {
              icon = "󱓞 ",
              key = "n",
              desc = "New Note",
              action = ":lua Snacks.dashboard.pick('files', {cwd='~/obsidian/00-Inbox'})",
            },
            {
              icon = " ",
              key = "o",
              desc = "Search Vault",
              action = ":lua Snacks.dashboard.pick('live_grep', {cwd='~/obsidian'})",
            },

            -- Engineering Section (The Builder)
            { icon = "󰙅 ", key = "p", desc = "Active Projects", action = ":lua Snacks.dashboard.pick('projects')" },
            { icon = " ", key = "g", desc = "Git Workflow", action = ":LazyGit" },

            -- Operations Section (The Ship)
            {
              icon = "󱠔 ",
              key = "k",
              desc = "K8s Manifests",
              action = ":tcd ~/obsidian/40-Orchestration | Telescope find_files",
            },
            {
              icon = "󱁢 ",
              key = "t",
              desc = "Terraform / IaC",
              action = ":tcd ~/obsidian/50-IaC-Config | Telescope find_files",
            },
            { icon = " ", key = "q", desc = "Ship & Exit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          -- LINKING THE FUNCTION (Prevents it from being greyed out)
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
