return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        -- 1. THE DEVOPS PERSONA
        opts = {
          system_prompt = function()
            return [[
You are a Senior DevOps Engineer and expert Lua developer assisting a user in a professional "Frictionless" Neovim environment (DKS). 
Tone: Professional, Concise, Technical.
Constraints: Direct answers. Modular code. No fluff.
            ]]
          end,
        },

        -- 2. STRATEGIES (The Frictionless Fix)
        strategies = {
          chat = {
            adapter = "gemini",
            -- AUTO-INSERT: Start typing immediately when opened
            start_in_insert_mode = true,
            keymaps = {
              send = {
                modes = { n = "<CR>", i = "<CR>" }, -- Enter to Send
              },
              close = {
                modes = { n = "q" }, -- q to Close
              },
            },
          },
          inline = {
            adapter = "gemini",
          },
        },

        -- 3. ADAPTER
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                -- Your testing key
                api_key = "AIzaSyAWfEt2w1-f4riHV4qlsi8ZjZe6UIGh6Qo",
              },
              schema = {
                model = { default = "gemini-1.5-pro" },
              },
            })
          end,
        },
      })
    end,

    -- 4. KEYBINDINGS
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Diff" },
    },
  },
}
