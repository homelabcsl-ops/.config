return {
  -- Speedtyper: In-editor typing practice
  {
    "NStefan002/speedtyper.nvim",
    branch = "main",
    cmd = "Speedtyper",
    config = function()
      -- Execute settings commands only after the plugin loads
      -- 1. Disable sound (Fixes "No tools" error)
      vim.cmd("SpeedtyperSettings sound enabled false")
      -- 2. Set transparency (Optional)
      vim.cmd("SpeedtyperSettings window transparent true")
    end,
  },

  -- Vim-Be-Good: Gamified Vim motion practice
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
}
