local overrides = require "custom.plugins_conf.overrides"
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
      require "custom.plugins_conf.toggleterm"
    end,
    init = function()
      require("core.utils").load_mappings "toggleterm"
    end,
  },

  -- misc plugins
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    opts = {
      filters = {
        dotfiles = false,
        exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
        custom = { "^.git$" },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    cmd = "Neotree",
    config = function()
      require "custom.plugins_conf.neo_tree"
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    init = function()
      require("core.utils").load_mappings "neotree"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
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
          },
          n = {
            ["<c-n>"] = "cycle_history_next",
            ["<c-p>"] = "cycle_history_prev",
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
    },
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
          require "custom.plugins_conf.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins_conf.lspconfig"
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
      require("core.utils").load_mappings "live_grep_args"
    end,
  },

  {
    "akinsho/bufferline.nvim",
    lazy = false,
    config = function()
      require("bufferline").setup {}
      -- require("base46").load_highlight "bufferline"
    end,
    init = function()
      require("core.utils").load_mappings "bufferline"
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
      require "custom.plugins_conf.aerial"
    end,
    init = function()
      require("core.utils").load_mappings "aerial"
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
  },

  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
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
}
