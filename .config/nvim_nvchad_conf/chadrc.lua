-- First read our docs (completely) then check the example_config repo

local M = {}

M.mappings = require "custom.mappings"

M.plugins = "custom.plugins"

M.ui = {
  theme = "everforest",
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "block",
    overriden_modules = function(modules)
      if not modules then
        return
      end

      if not modules[2] then
        return
      end

      modules[2] = (function()
        local icon = " 󰈚 "
        local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
        local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and " " .. ft_icon) or icon
          end

          name = " " .. name .. " "
        end

        return "%#St_file_info#" .. icon .. name .. "%m" .. "%#St_file_sep#" .. "█"
      end)()
    end,
  },

  transparency = true,
  tabufline = {
    enabled = false,
  },

  hl_override = {
    -- CursorLine = { bg = "darker_black" }
    FloatBorder = { link = "LineNr" },
    ToggleTerm1FloatBorder = { link = "LineNr" },
    ToggleTerm1NormalFloat = { link = "LineNr" },
    CursorLine = { bg = "black2" }
  },

  hl_add = {
    -- BufferLineIndicatorSelected = { link = "BufferLineSeparator" }
    FlashLabel = { fg = "black", bg = "red" },
    -- DiagnosticUnderlineError = { undercurl = true, sp = "red" },
    -- DiagnosticUnderlineHint = { undercurl = true, sp = "blue" },
    -- DiagnosticUnderlineWarn = { undercurl = true, sp = "yellow" },
    TabLine = { link = "NonText" }, -- xxx cterm=underline ctermfg=15 ctermbg=242 gui=underline guibg=DarkGrey
    TabLineFill = { link = "WinBar" }, --    xxx cterm=reverse gui=reverse
  },
}

M.lazy_nvim = vim.tbl_deep_extend("force", require "plugins.configs.lazy_nvim", require "custom.plugins_conf.lazy_nvim")

return M
