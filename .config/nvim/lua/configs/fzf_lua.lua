local actions = require("fzf-lua").actions
require("fzf-lua").setup {
  "telescope",
  defaults = { formatter = "path.filename_first" },
  winopts = {
    height = 0.80,
    width = 0.87,
    preview = {
      wrap = "wrap",
      layout = "horizontal", -- horizontal|vertical|flex
      horizontal = "right:50%", -- right|left:size
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
  keymap = {
    builtin = {
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

  actions = {
    files = {
      ["default"] = actions.file_edit_or_qf,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
    },
  },
}
