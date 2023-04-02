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
			-- icon = "▌", -- this should be omitted if indicator style is not 'icon' ▌ ▋ ▊
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
		separator_style = {"", ""}, -- slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
		always_show_bufferline = true,
		sort_by = "insert_at_end",
	},
}

M.ts_textobj = {
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
			},
			include_surrounding_whitespace = true,
		},
	},
}

M.blankline = {
	indentLine_enabled = 1,
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
	show_current_context = true,
	show_current_context_start = false,
}

M.telescope = {
	defaults = {
		-- prompt_prefix = "   ",
		prompt_prefix = "",
		path_display = { shorten = { len = 3, exclude = { 1, 2, -2, -1 } } },
		history = false,
		cache_picker = {
			num_pickers = 5,
		},
		mappings = {
			i = {
				["<c-k>"] = "move_selection_previous",
				["<c-j>"] = "move_selection_next",
				["<c-n>"] = "cycle_history_next",
				["<c-p>"] = "cycle_history_prev",
                ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
			},
			n = {
				["<c-n>"] = "cycle_history_next",
				["<c-p>"] = "cycle_history_prev",
                ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
			},
		},
	},
	pickers = {
		buffers = {
			sort_mru = true,
			ignore_current_buffer = true,
			scroll_strategy = "limit",
		},
	},
	extensions_list = { "themes", "terms", "live_grep_args", "aerial" },
	extensions = {
		aerial = {
			default_selection_index = 1,
			-- Display symbols as <root>.<parent>.<symbol>
			show_nesting = {
				["_"] = false, -- This key will be the default
				json = true, -- You can set the option for specific filetypes
				yaml = true,
			},
		},
		live_grep_args = {
			auto_quoting = true, -- enable/disable auto-quoting
		},
	},
}

return M
