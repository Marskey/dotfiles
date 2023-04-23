-- First read our docs (completely) then check the example_config repo

local M = {}

M.mappings = require("custom.mappings")

M.plugins = "custom.plugins"

M.ui = {
	theme = "everforest",
	statusline = {
		theme = "default", -- default/vscode/vscode_colored/minimal
		-- default/round/block/arrow separators work only for default statusline theme
		-- round and block will work for minimal theme only
		separator_style = "block",
		overriden_modules = nil,
	},

	transparency = true,
	tabufline = {
		enabled = false,
	},

    hl_override = {
        -- CursorLine = { bg = "darker_black" }
        FloatBorder = { link = "LineNr" },
        ToggleTerm1FloatBorder = { link = "LineNr" },
        ToggleTerm1NormalFloat = { link = "LineNr" },
    },

    hl_add = {
        -- BufferLineIndicatorSelected = { link = "BufferLineSeparator" }
    }
}

return M
