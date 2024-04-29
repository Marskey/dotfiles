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

      if modules[1] then
        local _M = {}
        _M.modes = {
          ["n"] = { "NORMAL", "St_NormalMode" },
          ["no"] = { "NORMAL (no)", "St_NormalMode" },
          ["nov"] = { "NORMAL (nov)", "St_NormalMode" },
          ["noV"] = { "NORMAL (noV)", "St_NormalMode" },
          ["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
          ["niI"] = { "NORMAL i", "St_NormalMode" },
          ["niR"] = { "NORMAL r", "St_NormalMode" },
          ["niV"] = { "NORMAL v", "St_NormalMode" },
          ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
          ["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

          ["v"] = { "VISUAL", "St_VisualMode" },
          ["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
          ["V"] = { "V-LINE", "St_VisualMode" },
          ["Vs"] = { "V-LINE", "St_VisualMode" },
          [""] = { "V-BLOCK", "St_VisualMode" },

          ["i"] = { "INSERT", "St_InsertMode" },
          ["ic"] = { "INSERT (completion)", "St_InsertMode" },
          ["ix"] = { "INSERT completion", "St_InsertMode" },

          ["t"] = { "TERMINAL", "St_TerminalMode" },

          ["R"] = { "REPLACE", "St_ReplaceMode" },
          ["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
          ["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
          ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
          ["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
          ["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

          ["s"] = { "SELECT", "St_SelectMode" },
          ["S"] = { "S-LINE", "St_SelectMode" },
          [""] = { "S-BLOCK", "St_SelectMode" },
          ["c"] = { "COMMAND", "St_CommandMode" },
          ["cv"] = { "COMMAND", "St_CommandMode" },
          ["ce"] = { "COMMAND", "St_CommandMode" },
          ["r"] = { "PROMPT", "St_ConfirmMode" },
          ["rm"] = { "MORE", "St_ConfirmMode" },
          ["r?"] = { "CONFIRM", "St_ConfirmMode" },
          ["x"] = { "CONFIRM", "St_ConfirmMode" },
          ["!"] = { "SHELL", "St_TerminalMode" },
        }
        modules[1] = (function()
          if not vim.api.nvim_get_current_win() == vim.g.statusline_winid then
            return ""
          end

          local m = vim.api.nvim_get_mode().mode
          local current_mode = "%#" .. _M.modes[m][2] .. "#" .. "  " .. _M.modes[m][1]
          local mode_sep1 = "%#" .. _M.modes[m][2] .. "Sep" .. "#" .. "█"

          return current_mode .. mode_sep1 .. "█"
        end)()
      end

      if modules[2] then
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
      end
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
    CursorLine = { bg = "black2" },
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
