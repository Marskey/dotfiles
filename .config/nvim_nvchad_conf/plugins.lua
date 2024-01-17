local overrides = require "custom.plugins_conf.overrides"
return {
  {
    "NvChad/nvterm",
    enabled = false,
  },
  {
    "akinsho/toggleterm.nvim",
    enabled = true,
    cmd = { "ToggleTerm" },
    keys = { "<c-\\>" },
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
    enabled = true,
    opts = overrides.nvimtree,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    cmd = { "NeoTreeReveal", "NeoTreeFocusToggle", "NeoTreeShowToggle", "Neotree" },
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
    opts = require "custom.plugins_conf.telescope",
  },
  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = false, -- shows a list of your marks on ' and `
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
      window = {
        border = "single",
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
    enabled = true,
    lazy = false,
    config = function()
      require("stickybuf").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- dependencies = {
    --     -- format & linting
    --     {
    --         "jose-elias-alvarez/null-ls.nvim",
    --         config = function()
    --             require("custom.plugins_conf.null-ls")
    --         end,
    --     },
    -- },
    config = function()
      require "custom.plugins_conf.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  -- {
  --     "ggandor/leap.nvim",
  --     lazy = false,
  --     config = function()
  --         require("leap").add_default_mappings()
  --     end,
  -- },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = overrides.flash,
    init = function()
      require("core.utils").load_mappings "flash"
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
    "marskey/telescope-sg",
    dependencies = "telescope.nvim",
    init = function()
      require("core.utils").load_mappings "telescope_sg"
    end,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    lazy = false,
    opts = overrides.bufferline,
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
    dependencies = "williamboman/mason-lspconfig.nvim",
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
    opts = function()
      return require "custom.plugins_conf.cmp"
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = overrides.colorizer,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufEnter",
    config = function()
      require("nvim-treesitter.configs").setup(overrides.ts_textobj)
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    opts = overrides.blankline,
  },
  {
    "github/copilot.vim",
    enabled = false,
    event = "BufEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
        ["Neo-tree"] = false,
      }
    end,
    init = function()
      vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  -- {
  --     'iamcco/markdown-preview.nvim',
  --     event = "VeryLazy",
  --     build = function() vim.fn["mkdp#util#install"]() end,
  -- }
  {
    "folke/trouble.nvim",
    event = "BufEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    opts = {
      func_map = {
        split = "<C-s>",
      },
    },
  },
  {
    "Wansmer/treesj",
    -- enabled = false,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
      }
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "BufEnter",
    name = "barbecue",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      create_autocmd = false, -- prevent barbecue from updating itself automatically
      show_dirname = false,
    },
    init = function()
      vim.opt.updatetime = 200
      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup {
        line_num = {
          enable = false,
        },
        blank = {
          enable = false,
        },
        indent = {
          enable = false,
        },
      }
    end,
  },
}
