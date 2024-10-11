local actions = require("fzf-lua").actions

local function yank_filename(selected, opts)
  local ret = selected[1]:match "(%w+%.%w+)"
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
  local ret = selected[1]:match "(%w+%.%w+)"
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

require("fzf-lua").setup {
  "telescope",
  defaults = { formatter = "path.filename_first" },
  winopts = {
    height = 0.90,
    width = 0.77,
    preview = {
      wrap = "wrap",
      layout = "vertical", -- horizontal|vertical|flex
      vertical = "down:50%", -- right|left:size
      hidden = "hidden", -- hidden|nohidden
    },
  },
  fzf_opts = { ["--layout"] = "reverse", ["--marker"] = "+" },
  fzf_colors = {
    ["gutter"] = "-1",
  },
  hls = {
    cursorline = "CursorLine",
    cursorlinenr = "CursorLineNr",
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always -L --smart-case --max-columns=4096 -e",
  },
  keymap = {
    builtin = {
      ["<Esc>"] = "hide",
      ["<F1>"] = "toggle-help",
      ["<c-n>"] = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"] = "toggle-preview-wrap",
      ["<c-p>"] = "toggle-preview",
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
      ["<S-left>"] = "preview-page-reset",
    },
    fzf = {
      ["ctrl-z"] = "abort",
      ["ctrl-f"] = "forward-char",
      ["ctrl-b"] = "backward-char",
      ["ctrl-a"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["alt-a"] = "toggle-all",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"] = "toggle-preview-wrap",
      ["f4"] = "toggle-preview",
      ["ctrl-d"] = "preview-page-down",
      ["ctrl-u"] = "preview-page-up",
    },
  },

  files = {
    actions = {
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_filename,
    },
  },

  buffers = {
    actions = {
      ["ctrl-s"] = actions.file_split,
      ["ctrl-y"] = yank_buff_filename,
    },
  },
}
