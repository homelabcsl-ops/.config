-- lua/plugins/images.lua
return {
  -- 1. The Dependency Manager (Installs the 'magick' glue code)
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- Very important: This must load before image.nvim
    opts = {
      rocks = { "magick" }, -- Automatically install the magick Lua rock
    },
  },

  -- 2. The Image Rendering Engine
  {
    "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    event = "VeryLazy",
    opts = {
      backend = "kitty", -- Works for Kitty, WezTerm, and Ghostty
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width = 100,
      max_height = 20,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = false,
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
  },
}
