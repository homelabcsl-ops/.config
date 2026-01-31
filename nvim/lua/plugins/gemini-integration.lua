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

        -- 2. STRATEGIES (Force Insert & Chat App Feel)
        strategies = {
          chat = {
            adapter = "gemini",
            keymaps = {
              send = {
                modes = { n = "<C-s>", i = "<C-s>" }, -- Ctrl+s to Send
              },
              close = {
                modes = { n = "q" },
              },
            },
          },
          inline = { adapter = "gemini" },
        },

        -- 3. ADAPTER (FIXED MODEL NAME)
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "AIzaSyAWfEt2w1-f4riHV4qlsi8ZjZe6UIGh6Qo",
              },
              schema = {
                model = {
                  -- CRITICAL FIX: Explicitly set to Flash to stop the 429 Error
                  default = "gemini-1.5-flash",
                },
              },
            })
          end,
        },
      })

      -- 4. FORCE INSERT MODE (The "Hammer")
      -- This ensures you can type immediately
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
