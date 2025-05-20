local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "vimdoc",
    "lua",
    "c",
    "markdown",
    "markdown_inline",
    "bash",
    "python",
  },
  additional_vim_regex_highlighting = false,
  indent = {
    enable = true,
    disabltruee = {
      "python",
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",
    "clangd",
    "jsonls",
    "python-lsp-server",
    "jq",
    "json-lsp",
    "bash",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  view = {
    centralize_selection = true,
    number = true,
    relativenumber = true,
    side = "left",
    width = { min = 30 },
    preserve_window_proportions = true,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  on_attach = function(bufnr)
    local api = require "nvim-tree.api"
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "go", function()
      local currentNode = api.tree.get_node_under_cursor()
      local path = currentNode.absolute_path
      if vim.fn.has "mac" == 1 or vim.fn.has "macunix" == 1 then
        vim.api.nvim_command("silent !open -R " .. path)
      elseif vim.fn.has "unix" == 1 then
        vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
      end
    end, opts "reveal in finder")
  end,
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
    separator_style = { "", "" }, -- slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
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
      include_surrounding_whitespace = false,
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      },
    },
  },
}

M.blankline = {
  scope = {
    enabled = false,
  },
}

M.flash = {
  modes = {
    search = {
      enabled = false,
    },
    char = {
      multi_line = false,
      jump_labels = true,
      highlight = { backdrop = true },
      jump = {
        -- when using jump labels, set to 'true' to automatically jump
        -- or execute a motion when there is only one match
        autojump = false,
      },
      char_actions = function(motion)
        return {
          [";"] = "next", -- set to `right` to always go right
          [","] = "prev", -- set to `left` to always go left
          -- clever-f style
          -- jump2d style: same case goes next, opposite case goes prev
          -- [motion] = "next",
          -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
        }
      end,
    },
  },
  label = {
    after = false, ---@type boolean|number[]
    before = true, ---@type boolean|number[]
    -- style = "inline", ---@type "eol" | "overlay" | "right_align" | "inline"
  },
}

-- local cmp = require "cmp"
-- M.cmp = {
--   completion = {
--     completeopt = "menu,menuone,noselect",
--   },
--   mapping = {
--     ["<CR>"] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Insert,
--       select = false,
--     },
--   },
-- }

M.codecompanion = {
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ", -- Prompt used for interactive LLM calls
      provider = "default", -- Can be "default", "telescope", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
  },
  adapters = {
    deepseek = function()
      return require("codecompanion.adapters").extend("deepseek", {
        schema = {
          model = {
            default = "deepseek-chat",
          },
        },
      })
    end,
  },
  strategies = {
    -- Change the default chat adapter
    chat = {
      adapter = "deepseek",
    },
    inline = {
      adapter = "deepseek",
    },
  },
  prompt_library = {
    ["Review code changes"] = {
      strategy = "chat",
      description = "Review code changes using git diff",
      opts = {
        index = 10,
        is_default = true,
        is_slash_cmd = true,
        short_name = "review",
        auto_submit = true,
      },
      prompts = {
        {
          role = "user",
          content = function()
            return string.format(
              [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, could you review the diff and check if there are any bugs?:

```diff
%s
```
]],
              vim.fn.system "git diff --no-ext-diff --staged"
            )
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
  },
  -- opts = {
  --   log_level = "DEBUG", -- or "TRACE"
  -- },
}

M.blinkcmp = {
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = {
    preset = "default",
    -- ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    -- ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-space>"] = {},
    ["<C-k>"] = {
      "show",
      "show_documentation",
      "hide_documentation",
    },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    keyword = { range = 'full' },
    documentation = { auto_show = false },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        -- score_offset = 100,
        async = true,
      },
    },
  },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
  --
  -- See the fuzzy documentation for more information
  fuzzy = {
    implementation = "rust",
    sorts = {
      "exact",
      "score",
      "sort_text",
    },
  },

  cmdline = {
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },
    },
  },
}

return M
