local overrides = require "configs.overrides"
return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

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
      require "configs.toggleterm"
    end,
  },
  -- misc plugins
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    opts = overrides.nvimtree,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    cmd = { "NeoTreeReveal", "NeoTreeFocusToggle", "NeoTreeShowToggle", "Neotree" },
    config = function()
      require "configs.neo_tree"
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    url = "https://github.com/Marskey/telescope.nvim.git",
    branch = "experimental",
    cmd = "Telescope",
    opts = require "configs.telescope",
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "configs.fzf_lua"
    end,
    init = function()
      dofile(vim.g.base46_cache .. "telescope")
    end,
  },
  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    dependencies = "echasnovski/mini.icons",
    opts = {
      delay = 200,
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
      win = {
        border = "single",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
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
    config = function()
      require "configs.lspconfig"
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
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = "telescope.nvim",
  },
  {
    "marskey/telescope-sg",
    dependencies = "telescope.nvim",
    branch = "pretty_display",
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    lazy = false,
    opts = overrides.bufferline,
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
      require "configs.aerial"
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
    enabled = true,
    opts = overrides.cmp,
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
    enabled = true,
    opts = overrides.blankline,
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
    opts = {
      multiline = false,
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    opts = {
      func_map = {
        split = "<C-s>",
        filterr = "zd",
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
      show_modified = true,
    },
    init = function()
      vim.opt.updatetime = 200
      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        -- "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = false,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<C-J>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          ["*"] = false,
          ["lua"] = true,
        },
      }
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "deepseek",
        },
        inline = {
          adapter = "deepseek",
        },
      },
      -- opts = {
      --   log_level = "DEBUG", -- or "TRACE"
      -- },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "echasnovski/mini.diff", version = false },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
      }
    }
  },
}
