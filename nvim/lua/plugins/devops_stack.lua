return {
  -- 1. GIT OPS (The Control Center)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- 2. INTELLIGENT SCHEMAS (Kubernetes / GitHub Actions / Ansible)
  {
    "b0o/SchemaStore.nvim",
    version = false,
  },

  -- 3. DEBUGGING (DAP)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mason-org/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")
      ui.setup()
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
    },
  },

  -- 4. TESTING (The Final Boss: Schema-Complete Version)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        -- Essential Global State
        log_level = vim.log.levels.WARN,

        -- Fully Defined Shells (Satisfies top-level schema requirements)
        strategies = {},
        run = {},
        consumers = {},
        icons = { enabled = true },
        highlights = {},

        -- Required Nested Fields (Satisfies nested table validation)
        summary = { enabled = true, animated = true },
        output = { enabled = true, open_on_run = true },
        output_panel = { enabled = true },

        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
          options = {},
        },
        -- Infrastructure Adapters
        adapters = {
          require("neotest-python"),
          require("neotest-go"),
        },
      })
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
    },
  },

  -- 5. HTTP CLIENT (API Testing)
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>R", "", desc = "+Rest" },
      { "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send Request" },
      { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle Headers/Body" },
    },
    opts = {},
  },

  -- 6. INFRASTRUCTURE PRE-FLIGHT (Validation)
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>tv",
        function()
          local file = vim.fn.expand("%:t")
          local ext = vim.fn.expand("%:e")
          local cmd = ""
          if ext == "tf" then
            cmd = "terraform validate"
          elseif ext == "yaml" or ext == "yml" then
            cmd = "ansible-lint " .. file .. " || echo 'YAML check: ansible-lint not required'"
          else
            vim.notify("No validator for ." .. ext, vim.log.levels.WARN)
            return
          end
          require("snacks").terminal.open(cmd, {
            win = { position = "float", border = "rounded" },
            title = " 🏗️ IaC Pre-Flight: " .. file,
          })
        end,
        desc = "Validate IaC (Terraform/Ansible)",
      },
    },
  },
}
