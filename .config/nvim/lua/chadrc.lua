-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

local M = {}

M.ui = {
  -- theme = "everforest",
  cmp = {
    lspkind_text = true,
    style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = false,
    },
  },

  tabufline = {
    enabled = false,
  },

  -- transparency = true,
}

M.base46 = {
  hl_override = {
    CursorLine = { bg = "black2" },
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
  },

  hl_add = {
    -- BufferLineIndicatorSelected = { link = "BufferLineSeparator" }
    FlashLabel = { fg = "black", bg = "red" },
    DiagnosticUnderlineError = { undercurl = true, sp = "red" },
    DiagnosticUnderlineHint = { undercurl = true, sp = "blue" },
    DiagnosticUnderlineWarn = { undercurl = true, sp = "yellow" },
    -- TabLine = { link = "NonText" }, -- xxx cterm=underline ctermfg=15 ctermbg=242 gui=underline guibg=DarkGrey
    -- TabLineFill = { link = "WinBar" }, --    xxx cterm=reverse gui=reverse
  },
}
return M
