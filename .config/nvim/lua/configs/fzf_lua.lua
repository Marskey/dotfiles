local actions = require("fzf-lua").actions
local utils = require("fzf-lua").utils

local function yank_filename(selected, opts)
  local ret = selected[1]:match "([%w-_]+%.%w+)"
  if vim.o.clipboard == "unnamed" then
    vim.fn.setreg([[*]], ret)
  elseif vim.o.clipboard == "unnamedplus" then
    vim.fn.setreg([[+]], ret)
  else
    vim.fn.setreg([["]], ret)
  end
  -- copy to the yank register regardless
  vim.fn.setreg([[0]], ret)
end

local function yank_buff_filename(selected, opts)
  local ret = selected[1]:match "([%w-_]+%.%w+)"
  if vim.o.clipboard == "unnamed" then
    vim.fn.setreg([[*]], ret)
  elseif vim.o.clipboard == "unnamedplus" then
    vim.fn.setreg([[+]], ret)
  else
    vim.fn.setreg([["]], ret)
  end
  -- copy to the yank register regardless
  vim.fn.setreg([[0]], ret)
end

local function hl_validate(hl)
  return not utils.is_hl_cleared(hl) and hl or nil
end

require("fzf-lua").setup {
  defaults = { formatter = "path.filename_first" },
  winopts = {
    height = 0.90,
    width = 0.77,
    preview = {
      wrap = "wrap",
      layout = "vertical", -- horizontal|vertical|flex
      vertical = "down:50%", -- right|left:size
      hidden = "hidden", -- hidden|nohidden
      horizontal = "right:50%",
      flip_columns = 120,
      delay = 10,
      winopts = { number = true },
    },
  },
  fzf_args = "--bind=change:+first", -- reset cursor to first entry on key change
  fzf_opts = { ["--cycle"] = true, ["--layout"] = "reverse", ["--marker"] = "+ " },
  fzf_colors = {
    ["gutter"] = "-1",
    ["marker"] = { "fg", "TelescopePromptPrefix" },
    ["fg"] = { "fg", "TelescopeNormal" },
    ["bg"] = { "bg", "TelescopeNormal" },
    ["hl"] = { "fg", "TelescopeMatching" },
    ["fg+"] = { "fg", "TelescopeSelection" },
    ["bg+"] = { "bg", "TelescopeSelection" },
    ["hl+"] = { "fg", "TelescopeMatching" },
    ["info"] = { "fg", "TelescopeMultiSelection" },
    ["border"] = { "fg", "TelescopeBorder" },
    ["query"] = { "fg", "TelescopePromptNormal" },
    ["prompt"] = { "fg", "TelescopePromptPrefix" },
    ["pointer"] = { "fg", "TelescopeSelectionCaret" },
    ["header"] = { "fg", "TelescopeTitle" },
  },
  hls = {
    normal = hl_validate "TelescopeNormal",
    border = hl_validate "TelescopeBorder",
    title = hl_validate "TelescopePromptTitle",
    help_normal = hl_validate "TelescopeNormal",
    help_border = hl_validate "TelescopeBorder",
    preview_normal = hl_validate "TelescopeNormal",
    preview_border = hl_validate "TelescopeBorder",
    preview_title = hl_validate "TelescopePreviewTitle",
    -- builtin preview only
    cursor = hl_validate "Cursor",
    cursorline = "CursorLine",
    cursorlinenr = "CursorLineNr",
    search = hl_validate "IncSearch",
  },
  keymap = {
    builtin = {
      ["<Esc>"] = "hide",
      ["<F1>"] = "toggle-help",

      ["<c-j>"] = "preview-down",
      ["<c-k>"] = "preview-up",
      -- Only valid with the 'builtin' previewer
      ["<F3>"] = "toggle-preview-wrap",
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",
      -- ["<C-d>"] = "preview-page-down",
      -- ["<C-u>"] = "preview-page-up",
      ["<c-h>"] = "toggle-preview",
      ["<c-l>"] = "preview-page-reset",
    },
    fzf = {
      ["ctrl-z"] = "abort",
      ["ctrl-f"] = "forward-char",
      ["ctrl-b"] = "backward-char",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["alt-a"] = "toggle-all",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["ctrl-q"] = "select-all+accept",
    },
  },

  actions = {
    files = {
      ["enter"] = actions.file_edit_or_qf,
      ["ctrl-x"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      ["alt-q"] = actions.file_sel_to_qf,
    },
  },

  files = {
    actions = {
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_filename,
      ["ctrl-g"] = { fn = actions.toggle_ignore, reuse = true, header = false },
      ["alt-h"] = { fn = actions.toggle_hidden, reuse = true, header = false },
      ["alt-f"] = { fn = actions.toggle_follow, reuse = true, header = false },
    },
  },

  grep = {
    rg_opts = "--column --line-number --no-heading --color=always -L --smart-case --max-columns=4096 -e",
    rg_glob = true,
    silent = true,
    actions = {
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_filename,
      ["alt-i"] = { fn = actions.toggle_ignore, reuse = true, header = false },
      ["alt-h"] = { fn = actions.toggle_hidden, reuse = true, header = false },
      ["alt-f"] = { fn = actions.toggle_follow, reuse = true, header = false },
    },
  },

  lgrep_quickfix = {
      rg_opts = "--column --line-number --no-heading --color=always -L --max-columns=4096 -e",
      rg_glob = true,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_filename,
      ["alt-i"] = { fn = actions.toggle_ignore, reuse = true, header = false },
      ["alt-h"] = { fn = actions.toggle_hidden, reuse = true, header = false },
      ["alt-f"] = { fn = actions.toggle_follow, reuse = true, header = false },
  },

  oldfiles = {
    include_current_session = true,
    actions = {
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_filename,
    },
  },

  buffers = {
    keymap = { builtin = { ["<C-d>"] = false } },
    actions = {
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_buff_filename,
      ["ctrl-x"] = false,
      ["ctrl-d"] = { actions.buf_del, actions.resume },
    },
  },
}
