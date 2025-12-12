--[[
  🧠 OBSIDIAN SYSTEM (Snacks Edition)
  ===================================
  
  CORE WORKFLOW
  <leader>on  : New Note
  <leader>oo  : Search Notes (Snacks Grep)
  <leader>os  : Switch Note (Snacks Files)
  <leader>oi  : Paste Image
  <leader>ot  : Template
  <leader>ob  : Backlinks

  FILTERS
  <leader>op  : Active Projects (Snacks Filter)
  <leader>od  : Todos (Snacks Filter)

  SYSTEM
  Sync        : Auto-pull/push with Snacks notifications.
--]]

return {
  -- 1. SYSTEM DEPENDENCIES (Luarocks & Magick)
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = { rocks = { "magick" } },
  },

  -- 2. IMAGE RENDERING
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      backend = "kitty", -- Works for WezTerm, Kitty, Ghostty.
      integrations = {
        markdown = {
          enabled = true,
          download_remote_images = true,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width = 100,
      max_height = 12,
    },
  },

  -- 3. VISUALS (Render Markdown)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = { "1 ", "2 ", "3 ", "4 ", "5 ", "6 " } },
      checkbox = { enabled = true },
    },
  },

  -- 4. THE BRAIN (Obsidian.nvim)
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- REPLACING KEYS TO USE SNACKS PICKERS DIRECTLY
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Template" },

      -- SNACKS PICKER INTEGRATION --
      -- Search Content (Grep)
      {
        "<leader>oo",
        function()
          require("lazyvim.util").pick("live_grep", {
            cwd = vim.fn.expand("~/obsidian/personal"),
            title = "Search Vault",
          })()
        end,
        desc = "Search Notes",
      },

      -- Search Filenames (Files)
      {
        "<leader>os",
        function()
          require("lazyvim.util").pick("files", {
            cwd = vim.fn.expand("~/obsidian/personal"),
            title = "Find Note",
          })()
        end,
        desc = "Quick Switch",
      },

      -- Active Projects Filter
      {
        "<leader>op",
        function()
          require("lazyvim.util").pick("live_grep", {
            cwd = vim.fn.expand("~/obsidian/personal"),
            default_text = "status: active",
            title = "Active Projects",
          })()
        end,
        desc = "Active Projects",
      },

      -- Todos Filter
      {
        "<leader>od",
        function()
          require("lazyvim.util").pick("live_grep", {
            cwd = vim.fn.expand("~/obsidian/personal"),
            default_text = "- [ ] ",
            title = "Todos",
          })()
        end,
        desc = "Todos",
      },
    },
    opts = {
      workspaces = {
        { name = "personal", path = "~/obsidian/personal" },
        { name = "devops", path = "obsidian/devops" },
      },
      daily_notes = {
        folder = "dailies",
        date_format = "%Y-%m-%d",
        template = "daily.md",
      },
      templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      completion = { nvim_cmp = false, min_chars = 2 },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      ui = { enable = false }, -- Render-markdown handles UI
      note_id_func = function(title)
        return title and title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() or tostring(os.time())
      end,
    },
  },

  -- 5. SAFETY (Multi-Vault Git Auto-Sync)
  {
    "nvim-lua/plenary.nvim",
    name = "obsidian-git-sync",
    config = function()
      -- Define ALL your vaults here
      local vaults = {
        vim.fn.expand("~/obsidian/personal"),
        vim.fn.expand("~/obsidian/devops"),
      }

      -- Helper to run git commands
      local function run_git(path, args)
        local cmd = { "git", "-C", path }
        for _, v in ipairs(args) do
          table.insert(cmd, v)
        end
        return vim.fn.system(cmd)
      end

      -- Notification Helper
      local function notify(msg, level)
        if _G.Snacks then
          Snacks.notify(msg, { title = "Obsidian Git", level = level })
        else
          vim.notify(msg, level or vim.log.levels.INFO, { title = "Obsidian Git" })
        end
      end

      -- Auto-Pull on Open (Loops through all vaults)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          for _, vault in ipairs(vaults) do
            if vim.fn.isdirectory(vault) == 1 then
              vim.fn.jobstart({ "git", "-C", vault, "pull" }, {
                on_exit = function(_, code)
                  if code == 0 then
                    notify("Pulled: " .. vim.fn.fnamemodify(vault, ":t"))
                  end
                end,
              })
            end
          end
        end,
      })

      -- Auto-Push on Exit (Loops through all vaults)
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          for _, vault in ipairs(vaults) do
            if vim.fn.isdirectory(vault) == 1 then
              notify("Backing up: " .. vim.fn.fnamemodify(vault, ":t"))
              run_git(vault, { "add", "." })
              run_git(vault, { "commit", "-m", "Auto-backup" })
              run_git(vault, { "push" })
            end
          end
        end,
      })
    end,
  },
}
