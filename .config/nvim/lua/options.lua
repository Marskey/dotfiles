require "nvchad.options"

-- add yours here!

local opt = vim.opt
local g = vim.g

opt.confirm = true
opt.cursorlineopt = "both" -- to enable cursorline!
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
opt.mousemodel = "extend"
opt.jumpoptions = "stack"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
-- opt.termguicolors = true
opt.timeoutlen = 1000
opt.undofile = true
opt.wrap = true -- display lines as one long line
-- opt.foldmethod = "indent"

opt.foldenable = true
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldtext = ""
opt.foldcolumn = "0"
-- vim.opt.fillchars:append({fold = ">"})
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method "textDocument/foldingRange" then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
--
-- opt.foldlevelstart = 99
-- opt.foldlevel = 99
-- opt.foldopen:remove{"hor"}

opt.list = true
opt.listchars:append "space:⋅,trail:⋅,tab:→ ,eol:↵"

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"
-- opt.guifont = "MesloLGS NF:h15"
opt.linespace = -6

g.mapleader = " "
g.vscode_snippets_path = "./lua/configs/my_snippets"

opt.guicursor =
  "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250,sm:block-blinkwait175-blinkoff150-blinkon175"

if vim.fn.has "nvim" and vim.fn.executable "nvr" then
  vim.env.GIT_EDITOR = "nvr -l --remote"
end

vim.cmd [[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
    augroup END
]]

vim.cmd [[ autocmd User TelescopePreviewerLoaded setlocal wrap ]]
vim.cmd [[ autocmd VimEnter * :clearjumps ]]

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

autocmd("VimEnter", {
  command = ":silent !kitty @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
  command = ":silent !kitty @ set-spacing padding=20 margin=10",
})

vim.api.nvim_create_user_command("Json2lua", function(args)
  local line1 = args.line1
  local line2 = args.line2
  local cur_buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(cur_buffer, line1 - 1, line2, false)
  local content = table.concat(lines)
  if content:find('\\"') or content:find("\\\\") or content:find("\\n") or content:find("\\t") then
    content = load("return " .. content)()
  end
  local ret = vim.json.decode(content, { luanil = { object = true, array = true } })
  local stringData = vim.inspect(ret)
  stringData = string.gsub(stringData, "vim.empty_dict%(%)", "{}")
  vim.api.nvim_buf_set_lines(cur_buffer, line1 - 1, line2, false, vim.split(stringData, "\n"))
end, { range = true })

vim.api.nvim_create_user_command("Unescape", function(args)
  local line1 = args.line1
  local line2 = args.line2
  local cur_buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(cur_buffer, line1 - 1, line2, false)
  local content = table.concat(lines)
  if content:find('\\"') or content:find("\\\\") or content:find("\\n") or content:find("\\t") then
    content = load("return " .. content)()
  end
  local stringData = content
  vim.api.nvim_buf_set_lines(cur_buffer, line1 - 1, line2, false, vim.split(stringData, "\n"))
end, { range = true })

