return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- 1. DEFINE THE TITANIUM PALETTE
      -- The "Charcoal & Metal" aesthetic with Neon Accents
      local c = {
        charcoal = "#161616", -- Main Bar Background (Matte)
        metal = "#2a2a2e", -- Inactive/Info Sections
        fg = "#c0c0c0", -- Standard Text

        -- Accents
        teal = "#73daca", -- INSERT Mode / Docker / Primary Accent
        purple = "#9d7cd8", -- VISUAL Mode / Terraform
        blue = "#7aa2f7", -- NORMAL Mode indicator
        red = "#f7768e", -- ERROR / REPLACE Mode
        orange = "#e0af68", -- COMMAND Mode
        green = "#9ece6a", -- GIT Success
      }

      -- 2. DEFINE THE CUSTOM TITANIUM THEME
      -- This enforces the flat, industrial look across all modes
      local titanium_theme = {
        normal = {
          a = { bg = c.metal, fg = c.blue, gui = "bold" },
          b = { bg = c.charcoal, fg = c.fg },
          c = { bg = c.charcoal, fg = c.fg },
        },
        insert = {
          a = { bg = c.teal, fg = c.charcoal, gui = "bold" }, -- High Contrast Neon Teal
          b = { bg = c.charcoal, fg = c.teal },
          c = { bg = c.charcoal, fg = c.fg },
        },
        visual = {
          a = { bg = c.purple, fg = c.charcoal, gui = "bold" },
          b = { bg = c.charcoal, fg = c.purple },
          c = { bg = c.charcoal, fg = c.fg },
        },
        command = {
          a = { bg = c.orange, fg = c.charcoal, gui = "bold" },
          b = { bg = c.charcoal, fg = c.orange },
          c = { bg = c.charcoal, fg = c.fg },
        },
        replace = {
          a = { bg = c.red, fg = c.charcoal, gui = "bold" },
          b = { bg = c.charcoal, fg = c.red },
          c = { bg = c.charcoal, fg = c.fg },
        },
        inactive = {
          a = { bg = c.charcoal, fg = c.metal, gui = "bold" },
          b = { bg = c.charcoal, fg = c.metal },
          c = { bg = c.charcoal, fg = c.metal },
        },
      }

      -- 3. CUSTOM DEVOPS LOGIC (Context Detection)
      local function devops_context()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if buf_name:match("%.tf$") then
          return "󱁢 IaC"
        elseif buf_name:match("docker") or buf_name:match("Dockerfile") then
          return " OPS"
        end
        return ""
      end

      -- 4. FINAL CONFIGURATION RETURN
      return {
        options = {
          theme = titanium_theme, -- Using our custom table defined above
          globalstatus = true,
          component_separators = "|",
          section_separators = "", -- Flat aesthetic (No powerline arrows)
        },
        sections = {
          lualine_a = { { "mode", gui = "bold" } },
          lualine_b = { { "branch", icon = "" } },
          lualine_c = {
            { "filetype", icon_only = true, colored = false }, -- Monochrome icons for stealth look
            { "filename", path = 1 }, -- Relative path
          },
          lualine_x = {
            -- DevOps Context Indicators (Integrated with Titanium Colors)
            {
              devops_context,
              color = function()
                local name = vim.api.nvim_buf_get_name(0)
                if name:match("%.tf$") then
                  return { fg = c.purple, gui = "bold" } -- Titanium Purple for Terraform
                end
                return { fg = c.teal, gui = "bold" } -- Titanium Teal for Docker
              end,
            },
            {
              function()
                return "DKS"
              end,
              color = { fg = c.metal }, -- Subtle branding
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
