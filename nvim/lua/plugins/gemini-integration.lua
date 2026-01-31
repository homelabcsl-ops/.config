return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        -- 1. THE DEVOPS PERSONA (System Prompt)
        opts = {
          -- FIX: Removed 'default' argument to silence the "Unused local" warning
          system_prompt = function()
            return [[
You are a Senior DevOps Engineer and expert Lua developer assisting a user in a professional "Frictionless" Neovim environment (DKS). 

Your Profile:
- Role: Senior DevOps Engineer / SRE
- Tone: Professional, Concise, Technical, "No-Fluff"
- Key Stack: Kubernetes, Terraform, Ansible, Lua (Neovim), Obsidian (Knowledge Management).

Your Constraints:
1. ANSWERS: Be direct. Do not waffle. Do not apologize. Start with the solution.
2. CODE: Always provide clean, modular, and commented code. Use "local" for Lua variables.
3. CONTEXT: You are integrated into Neovim. You can see the user's buffers.
4. PHILOSOPHY: value "Frictionless" workflows. Kelsey Hightower principles. Automation is key.
            ]]
          end,
        },

        -- 2. STRATEGIES (Chat App Feel)
        strategies = {
          chat = {
            adapter = "gemini",
            -- FIX: Explicit Keymaps to force "Enter to Send"
            keymaps = {
              send = {
                modes = { n = "<CR>", i = "<CR>" }, -- Press ENTER to Send
              },
              close = {
                modes = { n = "q" }, -- Press q to Close (Normal mode only)
              },
            },
          },
          inline = {
            adapter = "gemini",
          },
        },

        -- 3. ADAPTER CONFIGURATION
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                -- Hardcoded key as requested for testing
                api_key = "AIzaSyAWfEt2w1-f4riHV4qlsi8ZjZe6UIGh6Qo",
              },
              schema = {
                model = {
                  default = "gemini-1.5-pro",
                },
              },
            })
          end,
        },
      })
    end,

    -- 4. KEYBINDINGS
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions Palette" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Prompt (Diff)" },
      { "<leader>ad", "<cmd>CodeCompanion /buffer Explain this code<cr>", mode = "v", desc = "Explain Selection" },
      { "<leader>af", "<cmd>CodeCompanion /fix Fix this bug<cr>", mode = "v", desc = "Fix Selection" },
    },
  },
}
