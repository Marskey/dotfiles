-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

local utils = require "nvchad.stl.utils"
local M = {}

M.___stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.___lsp = function()
  if rawget(vim, "lsp") then
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.attached_buffers[M.___stbufnr()] then
        return (vim.o.columns > 100 and " 󰅡 " .. client.name .. " ") or " 󰅡 "
      end
    end
  end

  return ""
end

M.ui = {
  statusline = {
    theme = "default",
    separator_style = "round",
    modules = {
      lsp = function()
        return "%#St_Lsp#" .. M.___lsp()
      end,
      cursor = "%#St_pos_sep#" .. "" .. "%#St_pos_icon# %#St_pos_text# %p %% ",
    },
  },
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
  theme = "everforest",
  hl_override = {
    -- CursorLine = { bg = "black2" },
    St_cwd_sep = { fg = "#e29da2" },
    St_cwd_icon = { bg = "#e29da2" },
    St_cwd_text = { link = "St_cwd_icon" },
    St_pos_sep = { bg = "#e29da2", fg = "#e8c8c8" },
    St_pos_icon = { bg = "#e8c8c8" },
    St_pos_text = { link = "St_pos_icon" },
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
