--1. THE TELEMETRY ENGINE (Mac-Specific)
local function get_system_stats()
  -- 1. Fetch CPU Load (Native Mac sysctl)
  local cpu_handle = io.popen("sysctl -n vm.loadavg | awk '{print $2}'")
  local cpu = "0.00"
  if cpu_handle then
    cpu = vim.trim(cpu_handle:read("*a") or "0.00")
    cpu_handle:close()
  end

  -- 2. Fetch Memory (Simplified vm_stat for Mac)
  -- We avoid complex piping here to ensure it never returns nil
  local mem_handle = io.popen("vm_stat | awk '/Pages free/ {print $3}' | sed 's/\\.//'")
  local mem = "Active"
  if mem_handle then
    local pages = mem_handle:read("*a")
    mem_handle:close()
    if pages and pages ~= "" then
      -- Convert pages to approximate MB (Page size is 4096)
      mem = math.floor((tonumber(pages) * 4096) / 1024 / 1024) .. "MB Free"
    end
  end

  return string.format("󰻠 CPU: %s | 󰍛 MEM: %s", cpu, mem)
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
