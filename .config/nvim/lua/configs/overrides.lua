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
  ui = {
    border = "single",
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
  },
}

M.blankline = {
  scope = {
    enabled = false,
  },
}

M.lazy = {
  ui = {
    border = "single",
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
      highlight = { backdrop = false },
    },
  },
}

return M
