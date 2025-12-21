-- File: ~/.config/nvim/lua/plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local colors = {
        bg = "#161617",
        bg_dark = "#0f0f10",
        fg = "#c1c1c1",
        terraform = "#5c4ee5", -- Terraform Purple
        docker = "#0db9d7", -- Docker Blue
        gray = "#787c99",
      }

      -- Custom Function to detect IaC / Container context
      local function devops_context()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if buf_name:match("%.tf$") then
          return "󱁢 IaC"
        elseif buf_name:match("docker") or buf_name:match("Dockerfile") then
          return " OPS"
        end
        return ""
      end

      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = { { "mode", gui = "bold" } },
          lualine_b = { { "branch", icon = "" } },
          lualine_c = {
            { "filetype", icon_only = true },
            { "filename", path = 1 },
          },
          lualine_x = {
            -- DevOps Context Indicators
            {
              devops_context,
              color = function()
                local name = vim.api.nvim_buf_get_name(0)
                if name:match("%.tf$") then
                  return { fg = colors.terraform }
                end
                return { fg = colors.docker }
              end,
            },
            {
              function()
                return "DKS v1.6.0"
              end,
              color = { fg = colors.gray },
            },
            "diagnostics",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
}
