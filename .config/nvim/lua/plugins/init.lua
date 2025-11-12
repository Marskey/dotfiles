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
    enabled = true,
    opts = overrides.nvimtree,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
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
    enabled = false,
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
    enabled = false,
    lazy = false,
  },
  {
    "stevearc/stickybuf.nvim",
    enabled = false,
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
    "Marskey/flash.nvim",
    event = "VeryLazy",
    branch = "register_fix",
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
    enabled = false,
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
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = overrides.mason_lsp,
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
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
    enabled = false,
    opts = overrides.cmp,
  },
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
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
    enabled = false,
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
      preview = {
        winblend = 0,
      },
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
      vim.opt.updatetime = 50
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
    enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = false,
          auto_trigger = false,
          hide_during_completion = true,
          debounce = 75,
          -- keymap = {
          --   accept = "<C-J>",
          --   accept_word = false,
          --   accept_line = false,
          --   next = "<M-]>",
          --   prev = "<M-[>",
          --   dismiss = "<C-]>",
          -- },
        },
        panel = { enabled = false },
        filetypes = {
          ["*"] = false,
          ["lua"] = true,
        },
      }
    end,
  },
  {
    "Exafunction/windsurf.nvim",
    event = "BufEnter",
    config = function()
      require("codeium").setup {
        -- Optionally disable cmp source if using virtual text only
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,

          -- These are the defaults

          -- Set to true if you never want completions to be shown automatically.
          manual = false,
          -- A mapping of filetype to true or false, to enable virtual text.
          filetypes = {},
          -- Whether to enable virtual text of not for filetypes not specifically listed above.
          default_filetype_enabled = true,
          -- How long to wait (in ms) before requesting completions after typing stops.
          idle_delay = 75,
          -- Priority of the virtual text. This usually ensures that the completions appear on top of
          -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
          -- desired.
          virtual_text_priority = 65535,
          -- Set to false to disable all key bindings for managing completions.
          map_keys = true,
          -- The key to press when hitting the accept keybinding but no completion is showing.
          -- Defaults to \t normally or <c-n> when a popup is showing.
          accept_fallback = nil,
          -- Key bindings for managing completions in virtual text mode.
          key_bindings = {
            -- Accept the current completion.
            accept = "<C-j>",
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = false,
            -- Clear the virtual text.
            clear = false,
            -- Cycle to the next completion.
            next = "<M-]>",
            -- Cycle to the previous completion.
            prev = "<M-[>",
          },
        },
      }
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = overrides.codecompanion,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "echasnovski/mini.diff",
    enabled = false,
    version = false,
  },
  {
    "OXY2DEV/markview.nvim",
    enabled = true,
    ft = { "markdown", "codecompanion" },
    lazy = true,
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {},
      },
      markdown = {
        headings = {
          heading_1 = { sign = "" },
          heading_2 = { sign = "" },
        },
      },
      code_blocks = { sign = false },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    event = "VeryLazy",
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    event = "BufEnter",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end,
  },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    -- dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot" },
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = overrides.blinkcmp,
    opts_extend = { "sources.default" },
    init = function()
      dofile(vim.g.base46_cache .. "blink")
    end,
  },
  {
    "aaronik/treewalker.nvim",
    event = "BufEnter",
    -- The following options are the defaults.
    -- Treewalker aims for sane defaults, so these are each individually optional,
    -- and setup() does not need to be called, so the whole opts block is optional as well.
    opts = {
      -- Whether to briefly highlight the node after jumping to it
      highlight = true,

      -- How long should above highlight last (in ms)
      highlight_duration = 250,

      -- The color of the above highlight. Must be a valid vim highlight group.
      -- (see :h highlight-group for options)
      highlight_group = "CursorLine",

      -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
      --  true: All movements more than 1 line are added to the jumplist. This is the default,
      --        and is meant to cover most use cases. It's modeled on how { and } natively add
      --        to the jumplist.
      --  false: Treewalker does not add to the jumplist at all
      --  "left": Treewalker only adds :Treewalker Left to the jumplist. This is usually the most
      --          likely one to be confusing, so it has its own mode.
      jumplist = true,
    },
  },
  -- {
  --   "notjedi/nvim-rooter.lua",
  --   event = "BufEnter",
  --   opts = {
  --     rooter_patterns = { ".git" },
  --     trigger_patterns = { "*" },
  --     manual = false,
  --     fallback_to_parent = false,
  --     cd_scope = "global",
  --   },
  -- },
}
