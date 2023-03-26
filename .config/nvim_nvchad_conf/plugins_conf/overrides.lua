local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"c",
		"markdown",
		"markdown_inline",
	},
	additional_vim_regex_highlighting = false,
	indent = {
		enable = true,
		disable = {
			"python",
		},
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.cmp = {
	completion = {
		completeopt = "menu,menuone,noselect",
	},
}

M.colorizer = {
	user_default_options = {
		names = false,
	},
}
return M
