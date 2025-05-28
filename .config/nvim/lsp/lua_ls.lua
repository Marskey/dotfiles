return {
  settings = {
    Lua = {
      hint = {
        enable = true,
        setType = true,
      },
      format = {
        enable = false,
        -- Put format options here
        -- NOTE: the value should be STRING!!
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      diagnostics = {
        enable = true,
        globals = { "vim" },
        -- workspaceDelay = 6000,
      },
      workspace = {
        useGitIgnore = true,
        -- maxPreload = 5000,
        checkThirdParty = true,
        -- library = {
        --   [vim.fn.expand "$VIMRUNTIME/lua"] = true,
        --   [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        --   [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
        --   [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        -- },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      runtime = {
        version = "lua 5.3",
        special = {
          include = "require",
          gSingleton = "require",
        },
        pathStrict = false,
      },
      completion = {
        enable = true,
        autoRequire = true,
      },
    },
  },
}
