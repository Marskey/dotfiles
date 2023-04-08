local overrides = require("custom.plugins_conf.overrides")
return {
	{
		"NvChad/ui",
		opts = {
			statusline = {
				separator_style = "block",
			},
			tabufline = {
				enabled = false,
				overriden_modules = nil,
			},
		},
	},

	{
		"NvChad/nvterm",
		enabled = false,
	},

	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm" },
		config = function()
			require("custom.plugins_conf.toggleterm")
		end,
		init = function()
			require("core.utils").load_mappings("toggleterm")
		end,
	},

	-- misc plugins
	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		cmd = "Neotree",
		config = function()
			require("custom.plugins_conf.neo_tree")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		init = function()
			require("core.utils").load_mappings("neotree")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		opts = overrides.telescope,
	},

	-- Only load whichkey after all the gui
	{
		"folke/which-key.nvim",
		opts = {
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
					motions = false, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},
		},
	},

	{
		"tpope/vim-surround",
		lazy = false,
	},

	{
		"tommcdo/vim-exchange",
		lazy = false,
	},

	{
		"stevearc/stickybuf.nvim",
		lazy = false,
		config = function()
			require("stickybuf").setup()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.plugins_conf.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins_conf.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			require("leap").add_default_mappings()
		end,
	},

	{
		"nvim-telescope/telescope-live-grep-args.nvim",
		dependencies = "telescope.nvim",
		init = function()
			require("core.utils").load_mappings("live_grep_args")
		end,
	},

	{
		"akinsho/bufferline.nvim",
		lazy = false,
		opts = overrides.bufferline,
		init = function()
			require("core.utils").load_mappings("bufferline")
		end,
	},

	{
		"tiagovla/scope.nvim",
		lazy = false,
		config = function()
			require("scope").setup()
		end,
	},

	{
		"stevearc/aerial.nvim",
		dependencies = "telescope.nvim",
		cmd = {
			"AerialToggle",
			"AerialOpen",
			"AerialOpenAll",
			"AerialClose",
			"AerialCloseAll",
			"AerialNext",
			"AerialPrev",
			"AerialGo",
			"AerialInfo",
		},
		config = function()
			require("custom.plugins_conf.aerial")
		end,
		init = function()
			require("core.utils").load_mappings("aerial")
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
	},

	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
        dependencies = "williamboman/mason-lspconfig.nvim"
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"numToStr/Comment.nvim",
		lazy = false,
	},

	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
	},

	{
		"NvChad/nvim-colorizer.lua",
		opts = overrides.colorizer,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "BufEnter",
        main = "nvim-treesitter.configs",
        opts = overrides.ts_textobj,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

    {
        "lukas-reineke/indent-blankline.nvim",
        opts = overrides.blankline,
    },

    {
        "github/copilot.vim",
        event = "BufEnter",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end
    }
}
