local map = vim.keymap.set
local vim_win_gettype = vim.fn.win_gettype
local function getVisualSelection()
  vim.cmd 'noau normal! "vy"'
  local text = vim.fn.getreg "v"
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

--Remap space as leader key
-- vim.api.nvim_set_keymap("", "<SPACE>", "<Nop>", { noremap = true, silent = true })

map("n", "*", ":keepjumps normal! mi*`i<CR>")
map("n", "<A-o>", "<cmd> !open %:p:h <CR>")
map("n", "<Space>", "<Nop>")
map("n", "<leader>x", "<cmd> bp<bar>sp<bar>bn<bar>bd <CR>", { desc = "close buffer without closing window" })

-- M.lspconfig = {

-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
map("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "lsp declaration" })

-- I puted it in lspconfig for loading preview feature
map("n", "gd", function()
  vim.lsp.buf.definition()
end)

map("n", "gi", function()
  vim.lsp.buf.implementation()
end, { desc = "lsp implementation" })

map("n", "<leader>lh", function()
  vim.lsp.buf.signature_help()
end, { desc = "lsp signature_help" })

map("n", "<leader>li", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "lsp toggle inlay hint" })

map("n", "<leader>D", function()
  vim.lsp.buf.type_definition()
end, { desc = "lsp definition type" })

map("n", "<leader>lr", function()
  vim.lsp.buf.rename()
  -- require("nvchad_ui.renamer").open()
end, { desc = "lsp rename" })

map("n", "<leader>la", function()
  vim.lsp.buf.code_action()
end, { desc = "lsp code_action" })

map("n", "gr", "<Cmd>kR<Bar>lua vim.lsp.buf.references()<CR>", { desc = "lsp references" })

map("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "floating diagnostic" })

map("n", "<leader>q", function()
  vim.diagnostic.setloclist()
end, { desc = "diagnostic setloclist" })

map({ "n", "v" }, "<leader>lf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "lsp formatting" })

-- }

-- M.neotree = {
-- toggle
-- map("n", "<C-n>", "<cmd> Neotree filesystem focus toggle <CR>", { desc = "toggle filetree" })
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>", { desc = "toggle filetree" })

-- focus
-- map("n", "<leader>e", "<cmd> Neotree filesystem reveal <CR>", { desc = "focus filetree" })
map("n", "<leader>e", "<cmd> NvimTreeFocus <CR>", { desc = "focus filetree" })
-- }

-- M.fzflua = {
map("n", "<leader>ff", "<cmd> FzfLua files line_query=true follow=true <CR>", { desc = "find files" })
map("v", "<leader>ff", function()
  require("fzf-lua").files {
    fzf_opts = {
      ["-q"] = getVisualSelection(),
    },
    line_query = true,
    follow = true
  }
end, { desc = "find files" })
map("n", "<leader>ft", "<cmd> FzfLua live_grep <CR>", { desc = "live grep" })
map("v", "<leader>ft", function()
  require("fzf-lua").live_grep {
    search = getVisualSelection(),
  }
end, { desc = "Find Text" })
map("n", "<leader>fb", "<cmd> FzfLua buffers <CR>", { desc = "find buffers" })
map("n", "<leader>fo", "<cmd> FzfLua oldfiles cwd_only=false line_query=true <CR>", { desc = "find oldfiles" })
map("n", "<leader>fr", "<cmd> FzfLua resume <CR>", { desc = "Resume last find" })
map("n", "<leader>fs", "<cmd> FzfLua lsp_document_symbols <CR>", { desc = "document symbols" })
map("n", "<leader>fw", "<cmd> FzfLua lsp_live_workspace_symbols <CR>", { desc = "workspace symbols" })
map("v", "<leader>fw", function()
  require("fzf-lua").lsp_live_workspace_symbols {
    query = getVisualSelection(),
  }
end, { desc = "workspace symbols" })
map("v", "<leader>fs", function()
  require("fzf-lua").lsp_document_symbols {
    query = getVisualSelection(),
  }
end, { desc = "document symbols" })
-- }

map("n", "<leader>gc", "<cmd> FzfLua git_bcommits <CR>", { desc = "git buffer commits" })

-- theme switcher
map("n", "<leader>ph", "<cmd> Telescope themes <CR>", { desc = "nvchad themes" })

local lazygit = nil
-- M.toggleterm = {

map("n", "<leader>gg", function()
  -- if not lazygit then
  local Terminal = require("toggleterm.terminal").Terminal
  lazygit = Terminal:new {
    cmd = "cd " .. vim.fn.expand "%:p:h" .. "&& lazygit",
    direction = "float",
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd "startinsert!"
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd "startinsert!"
      vim.cmd "checktime"
    end,

    on_exit = function(term)
      lazygit = nil
    end,
  }
  -- end
  lazygit:toggle()
end, { desc = "term lazygit" })
-- }

if not vim.env.ITERM then
  vim.api.nvim_buf_set_keymap(0, "t", "<D-v>", [[<C-\><C-n>"+pa]], { noremap = true })
end

-- M.gitsigns = {
-- Navigation through hunks
map("n", "<leader>gj", function()
  if vim.wo.diff then
    return "<learder>gj"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { desc = "Jump to next hunk" })

map("n", "<leader>gk", function()
  if vim.wo.diff then
    return "<leader>gk"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { desc = "Jump to prev hunk" })

-- Actions
map("n", "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })

map("n", "<leader>gs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })

map("n", "<leader>gu", function()
  require("gitsigns").undo_stage_hunk()
end, { desc = "Undo stage hunk" })

map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })

map("n", "<leader>gl", function()
  require("gitsigns").blame_line()
end, { desc = "Blame line" })

map("n", "<leader>gd", function()
  require("gitsigns").diffthis "HEAD"
end, { desc = "Diff this" })

map("n", "<leader>gb", function()
  require("gitsigns").blame()
end, { desc = "Toggle blame" })
-- }

-- M.aerial = {
map("n", "<leader>lo", "<cmd>AerialToggle<cr>", { desc = "Open outline" })
-- map("n", "<leader>ls", "<cmd> Telescope aerial default_selection_index=1 <CR>", { desc = "document functions" })
-- }

map("n", "<leader>fg", "<cmd> Telescope ast_grep<CR>", { desc = "Structural search" })
map("v", "<leader>fg", function()
  require("telescope").extensions.ast_grep.ast_grep {
    default_text = getVisualSelection(),
  }
end, { desc = "Structural search" })

-- M.flash = {
map("n", "s", function()
  if vim_win_gettype() ~= "command" then
    require("flash").jump()
  end
end, { desc = "Flash" })

map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })

map({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
map({ "o", "x" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

map("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
-- }

-- M.trouble {
map(
  "n",
  "<leader>tc",
  "<cmd> Trouble diagnostics toggle focus=false filter.buf=0 <CR>",
  { desc = "Toggle diagnostics for the current buffer" }
)
-- }

map("n", "<A-l>", "<C-W>>")
map("n", "<A-h>", "<C-W><")
map("n", "<A-k>", "<C-W>+")
map("n", "<A-j>", "<C-W>-")

map("n", "gs", function ()
  -- vim.cmd 'vsplit'
  -- vim.lsp.buf.definition()
  local fzf_lua = require("fzf-lua")
  fzf_lua.lsp_definitions({
    jump1_action = fzf_lua.actions.file_vsplit
  })
end)
