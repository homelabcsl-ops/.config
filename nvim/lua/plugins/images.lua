-- lua/plugins/images.lua
return {
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" }, -- Ensures the magick rock installs correctly
    event = "VeryLazy",
    opts = {
      backend = "kitty", -- Works for Kitty, WezTerm, and Ghostty.
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = 100,
      max_height = 20, -- Limits image height to avoid taking up the whole screen
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = false, -- Toggles image visibility if floating windows overlap
      editor_only_render_when_focused = false, -- Keep images visible even when inactive
      tmux_show_only_in_active_window = true, -- If using tmux, only show in active pane
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
    config = function(_, opts)
      -- Safety check: Only load if we are in a graphical terminal that supports it
      -- This prevents errors when you SSH in from a dumb terminal.
      local package_root = vim.fn.stdpath("data") .. "/lazy"
      local rocks_path = package_root .. "/image.nvim/rocks"
      package.path = package.path
        .. ";"
        .. rocks_path
        .. "/share/lua/5.1/?.lua;"
        .. rocks_path
        .. "/share/lua/5.1/?/init.lua"
      package.cpath = package.cpath .. ";" .. rocks_path .. "/lib/lua/5.1/?.so"

      require("image").setup(opts)
    end,
  },
}
