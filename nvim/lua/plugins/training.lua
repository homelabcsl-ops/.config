return {
  -- Speedtyper: In-editor typing practice
  {
    "NStefan002/speedtyper.nvim",
    branch = "main",
    cmd = "Speedtyper",
    config = function()
      -- 1. Initialize the plugin (with no arguments)
      require("speedtyper").setup()

      -- 2. Run settings commands safely wrapped in a function
      -- This fixes the "table" error you saw in the screenshot
      pcall(function()
        vim.cmd("SpeedtyperSettings sound enabled false")
        vim.cmd("SpeedtyperSettings window transparent true")
      end)
    end,
  },

  -- Vim-Be-Good: Gamified Vim motion practice
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
}
