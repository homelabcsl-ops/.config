local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 1. 🧭 Navigation & Shell (Your existing Mission Control setup)
config.default_prog = { "/bin/zsh", "-l", "-c", "~/bin/mission-control.sh" }
config.keys = {
	-- Send "Ctrl+h/j/k/l" to Tmux for the Unibody workflow
	{ key = "h", mods = "CTRL", action = wezterm.action.SendKey({ key = "h", mods = "CTRL" }) },
	{ key = "j", mods = "CTRL", action = wezterm.action.SendKey({ key = "j", mods = "CTRL" }) },
	{ key = "k", mods = "CTRL", action = wezterm.action.SendKey({ key = "k", mods = "CTRL" }) },
	{ key = "l", mods = "CTRL", action = wezterm.action.SendKey({ key = "l", mods = "CTRL" }) },
}

-- 2. 🎨 DKS Visual System (Titanium Theme)
-- We strictly define the colors to match your "Carbonfox" + "Teal" aesthetic.

config.colors = {
	-- 1. 🧬 Genetic Match with theme.lua
	-- We use the EXACT overrides from your plugin configuration
	background = "#161616", -- Your Custom "Deep Charcoal" (bg1)
	foreground = "#b6b8bb", -- Your "Foggy Grey" (fg1)

	-- UI Elements
	cursor_bg = "#008080", -- DKS Signature Teal (Kept for consistency)
	cursor_fg = "#161616",
	cursor_border = "#008080",

	selection_bg = "#2b2b2b", -- Your Custom "Subtle Selection" (sel0)
	selection_fg = "#b6b8bb",

	-- 2. 🌈 ANSI Palette (Standard Carbonfox)
	-- These match the syntax highlighting logic in nightfox.nvim
	ansi = {
		"#282828", -- Black
		"#ee5396", -- Red (Muted Brick)
		"#25be6a", -- Green
		"#08bdba", -- Yellow (Carbonfox uses a Teal-ish Yellow!)
		"#78a9ff", -- Blue
		"#be95ff", -- Magenta
		"#33b1ff", -- Cyan
		"#dfdfe0", -- White
	},
	brights = {
		"#484848", -- Bright Black
		"#f16da6", -- Bright Red
		"#46c880", -- Bright Green
		"#2dc7c4", -- Bright Yellow
		"#8cb6ff", -- Bright Blue
		"#c8a5ff", -- Bright Magenta
		"#52bdff", -- Bright Cyan
		"#e4e4e5", -- Bright White
	},
	-- 3. 📑 Tab Bar (Minimalist & Integrated)
	tab_bar = {
		background = "#090618",

		-- The Active Tab (Your current context)
		active_tab = {
			bg_color = "#008080", -- DKS Teal
			fg_color = "#16161d",
			intensity = "Bold",
		},

		-- Inactive Tabs (Background noise)
		inactive_tab = {
			bg_color = "#16161d",
			fg_color = "#727169",
		},

		new_tab = {
			bg_color = "#090618",
			fg_color = "#727169",
		},
	},
}

-- Visual Polish
config.window_decorations = "RESIZE" -- Removes title bar for cleaner look
config.use_fancy_tab_bar = false -- Fits the "Professional" utility aesthetic
config.font_size = 14.0 -- Readable professional standard

return config
