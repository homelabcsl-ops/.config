return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        -- 1. STRATEGIES (How the AI interacts)
        strategies = {
          -- Sidebar Chat (Like ChatGPT in your editor)
          chat = {
            adapter = "gemini",
          },
          -- Inline (Ghost Text / Diff View for code edits)
          inline = {
            adapter = "gemini",
          },
          -- Agent (Can execute slash commands)
          agent = {
            adapter = "gemini",
          },
        },
        -- 2. ADAPTER CONFIGURATION
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                -- READS THE KEY FROM YOUR ZSH CONFIG
                api_key = "cmd:echo $GEMINI_API_KEY",
              },
              schema = {
                model = {
                  -- Uses the high-performance Pro model
                  default = "gemini-1.5-pro",
                },
              },
            })
          end,
        },
      })
    end,
    -- 3. KEYBINDINGS
    keys = {
      -- Action Palette (The "Do It" Menu)
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions Palette" },
      -- Chat (Sidebar)
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      -- Inline Prompt (The "Ghost" Writer)
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Prompt (Diff)" },
      -- Quick Workflows
      { "<leader>ad", "<cmd>CodeCompanion /buffer Explain this code<cr>", mode = "v", desc = "Explain Selection" },
      { "<leader>af", "<cmd>CodeCompanion /fix Fix this bug<cr>", mode = "v", desc = "Fix Selection" },
    },
  },
}
