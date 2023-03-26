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

M.bufferline = {
	options = {
		indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
			style = "icon",
		},
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer",
				text_align = "center", --  | "center" | "right"
				separator = true,
			},
		},
		show_buffer_close_icons = false,
		separator_style = "thin", -- slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
		always_show_bufferline = false,
		sort_by = "insert_at_end",
	},
}

return M
