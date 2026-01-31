return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        -- 1. DEVOPS PERSONA
        opts = {
          system_prompt = function()
            return [[
You are a Senior DevOps Engineer in a "Frictionless" Neovim environment (DKS).
Tone: Professional, Concise.
Constraints: Direct answers. Modular code.
            ]]
          end,
        },

        -- 2. STRATEGIES (Frictionless Chat)
        strategies = {
          chat = {
            adapter = "gemini",
            keymaps = {
              -- Ctrl+s to Send (Works in Normal and Insert mode)
              send = {
                modes = { n = "<C-s>", i = "<C-s>" },
              },
              close = {
                modes = { n = "q" },
              },
            },
          },
          inline = { adapter = "gemini" },
        },

        -- 3. ADAPTER (Correct Model & Key)
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                -- Your Key (Hardcoded for immediate stability)
                api_key = "AIzaSyAWfEt2w1-f4riHV4qlsi8ZjZe6UIGh6Qo",
              },
              schema = {
                model = {
                  -- CRITICAL: Valid model name
                  default = "gemini-1.5-flash",
                },
              },
            })
          end,
        },
      })

      -- 4. AUTO-INSERT (Typing immediately)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "codecompanion",
        callback = function()
          vim.cmd("startinsert")
        end,
      })
    end,

    -- 5. KEYBINDINGS
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Diff" },
    },
  },
}
