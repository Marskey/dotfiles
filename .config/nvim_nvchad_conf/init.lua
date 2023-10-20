require("custom.options")

vim.cmd([[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
    augroup END
]])

vim.cmd([[ autocmd User TelescopePreviewerLoaded setlocal wrap ]])
vim.cmd([[ autocmd VimEnter * :clearjumps ]])

-- disable syntax for it's low performence
vim.cmd("syntax off")
