return {
  -- Speedtyper: In-editor typing practice
  {
    "NStefan002/speedtyper.nvim",
    cmd = "Speedtyper", -- Loads only when you run the command
    branch = "main",
    opts = {
      -- You can customize window transparency and colors here later
      window = {
        transparent = true,
      },
    },
  },

  -- Vim-Be-Good: Gamified Vim motion practice
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood", -- Loads only when you run the command
    -- REMOVED: build = "./install.sh" (Plugin is now pure Lua)
  },
}
