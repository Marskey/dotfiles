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
    -- dependencies = {
    --     -- format & linting
    --     {
    --         "jose-elias-alvarez/null-ls.nvim",
    --         config = function()
    --             require("configs.null-ls")
    --         end,
    --     },
    -- },
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
    "zbirenbaum/copilot.lua",
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
  -- {
  --   "github/copilot.vim",
  --   enabled = true,
  --   event = "VeryLazy",
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { replace_keycodes = false, expr = true })
  --     vim.g.copilot_filetypes = {
  --       ["*"] = false,
  --       ["lua"] = true,
  --       -- ["TelescopePrompt"] = false,
  --       -- ["Neo-tree"] = false,
  --     }
  --   end,
  -- },
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
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "deepseek",
      auto_suggestions_provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20241022",
        temperature = 0,
        max_tokens = 4096,
      },
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          -- endpoint = "https://api.deepseek.com",
          endpoint = "https://openrouter.ai/api/v1",
          -- model = "deepseek-coder",
          model = "deepseek/deepseek-r1:free",
        },
      },
      behaviour = {
        auto_suggestions = true,
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}

