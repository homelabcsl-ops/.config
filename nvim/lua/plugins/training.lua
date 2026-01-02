return {
  -- Typr: The modern, frictionless replacement for Speedtyper
  {
    "nvzone/typr",
    dependencies = "nvzone/volt", -- Required library
    cmd = { "Typr", "TyprStats" },
    opts = {
      -- It works out of the box, but you can tweak UI here
      ui = {
        win = {
          width = 0.8,
          height = 0.8,
        },
      },
    },
  },

  -- Vim-Be-Good: Gamified Vim motion practice
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
}
