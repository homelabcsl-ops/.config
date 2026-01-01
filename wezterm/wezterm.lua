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
	-- The "Industrial" Background (Carbonfox style)
	background = "#16161d",
	foreground = "#dcd7ba",

	cursor_bg = "#008080", -- DKS Teal Cursor
	cursor_fg = "#16161d",

	selection_bg = "#2d4f67",
	selection_fg = "#c8c093",

	-- The Color Palette (ANSI)
	ansi = {
		"#090618", -- Black
		"#c34043", -- Red
		"#76946a", -- Green
		"#c0a36e", -- Yellow
		"#7e9cd8", -- Blue
		"#957fb8", -- Magenta
		"#6a9589", -- Cyan (Teal-ish)
		"#c8c093", -- White
	},
	brights = {
		"#727169", -- Bright Black
		"#e82424", -- Bright Red
		"#98bb6c", -- Bright Green
		"#e6c384", -- Bright Yellow
		"#7fb4ca", -- Bright Blue
		"#938aa9", -- Bright Magenta
		"#7aa89f", -- Bright Cyan
		"#dcd7ba", -- Bright White
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
