local opt = vim.opt
local g = vim.g

opt.confirm = true
-- opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 1000
opt.undofile = true
opt.wrap = true -- display lines as one long line
opt.foldmethod = "indent"
opt.foldlevelstart = 99


opt.list = true
opt.listchars:append "space:⋅,trail:⋅,tab:→ "

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
opt.guifont = "Hack Nerd Font:h14"

g.mapleader = " "
g.vscode_snippets_path = "./lua/custom/my_snippets"

opt.guicursor =
"n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250,sm:block-blinkwait175-blinkoff150-blinkon175"

if vim.fn.has('nvim') and vim.fn.executable('nvr') then
    vim.env.GIT_EDITOR = "nvr -l --remote"
end
