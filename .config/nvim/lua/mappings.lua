require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del
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

unmap("i", "<C-b>")
unmap("i", "<C-e>")
unmap("i", "<C-h>")
unmap("i", "<C-l>")
unmap("i", "<C-j>")
unmap("i", "<C-k>")

unmap("n", "<TAB>")
unmap("n", "<S-Tab>")
unmap("n", "<Esc>")
unmap("n", "<C-h>")
unmap("n", "<C-l>")
unmap("n", "<C-j>")
unmap("n", "<C-k>")
unmap("n", "<C-s>")
unmap("n", "<C-c>")
unmap("n", "<leader>n")
unmap("n", "<leader>b")
unmap("n", "<leader>x")
unmap("n", "<leader>/")
unmap("n", "<leader>fm")
unmap("n", "<leader>cm")
unmap("n", "<leader>th")
unmap("n", "<leader>fw")
unmap("n", "<A-i>")
unmap("n", "<A-h>")
unmap("n", "<A-v>")
unmap("n", "<leader>h")
unmap("n", "<leader>v")
unmap("n", "<leader>fa")
unmap("v", "<leader>/")

--Remap space as leader key
-- vim.api.nvim_set_keymap("", "<SPACE>", "<Nop>", { noremap = true, silent = true })

map("n", "*", ":keepjumps normal! mi*`i<CR>")
map("n", "<A-o>", "<cmd> !open %:p:h <CR>")
map("n", "<Space>", "<Nop>")

-- M.lspconfig = {

-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
map("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "lsp declaration" })

-- I puted it in lspconfig for loading preview feature
-- map("n", "gd",

map("n", "gh", function()
  vim.lsp.buf.hover()
end, { desc = "lsp hover" })

map("n", "gi", function()
  vim.lsp.buf.implementation()
end, { desc = "lsp implementation" })

map("n", "<leader>lh", function()
  vim.lsp.buf.signature_help()
end, { desc = "lsp signature_help" })

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
map("n", "<C-n>", "<cmd> Neotree filesystem focus toggle <CR>", { desc = "toggle filetree" })

-- focus
map("n", "<leader>e", "<cmd> Neotree filesystem reveal <CR>", { desc = "focus filetree" })
-- }

-- M.fzflua = {
map("n", "<leader>ff", "<cmd> FzfLua files <CR>", { desc = "find files" })
map("v", "<leader>ff", function()
  require("fzf-lua").files {
    fzf_opts = {
      ["-q"] = getVisualSelection(),
    },
  }
end, { desc = "find files" })
-- }

-- M.telescope = {

-- find
-- ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
map("n", "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "find buffers" })
map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "help page" })
map("n", "<leader>fo", "<cmd> Telescope oldfiles only_cwd=true <CR>", { desc = "find oldfiles" })
map("n", "<leader>fk", "<cmd> Telescope keymaps <CR>", { desc = "show keys" })
map("n", "<leader>fj", "<cmd> Telescope jumplist <CR>", { desc = "jumplist" })
map("n", "<leader>fs", "<cmd> Telescope lsp_document_symbols <CR>", { desc = "document symbols" })
map("n", "<leader>fr", "<cmd> Telescope resume <CR>", { desc = "Resume last find" })
map("n", "<leader>fl", "<cmd> Telescope pickers <CR>", { desc = "find pickers cache" })
map("n", "<leader>ft", "<cmd> Telescope live_grep <CR>", { desc = "live grep" })

-- git
map("n", "<leader>gf", "<cmd> Telescope git_bcommits <CR>", { desc = "git buffer commits" })
map("n", "<leader>gm", "<cmd> Telescope git_commits <CR>", { desc = "git buffer commits" })
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>", { desc = "git status" })

-- pick a hidden term
map("n", "<leader>pt", "<cmd> Telescope terms <CR>", { desc = "pick hidden term" })

-- theme switcher
map("n", "<leader>ph", "<cmd> Telescope themes <CR>", { desc = "nvchad themes" })

-- ["<leader>ff"] = {
--   function()
--     require("telescope.builtin").find_files {
--       default_text = getVisualSelection(),
--     }
--   end,
--   "find files",
-- },
map("v", "<leader>ft", function()
  require("telescope.builtin").live_grep {
    default_text = getVisualSelection(),
    only_sort_text = true,
    additional_args = function()
      return { "--pcre2" }
    end,
  }
end, { desc = "Find Text" })
-- }

local lazygit = nil
-- M.toggleterm = {

map("n", "<leader>gg", function()
  if not lazygit then
    local Terminal = require("toggleterm.terminal").Terminal
    lazygit = Terminal:new {
      cmd = "lazygit",
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
  end
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
  package.loaded.gitsigns.blame_line()
end, { desc = "Blame line" })

map("n", "<leader>gd", function()
  require("gitsigns").diffthis "HEAD"
end, { desc = "Diff this" })

map("n", "<leader>gb", function()
  require("gitsigns").toggle_deleted()
end, { desc = "Toggle deleted" })
-- }

-- M.aerial = {
map("n", "<leader>lo", "<cmd>AerialToggle<cr>", { desc = "Open outline" })
map("n", "<leader>ls", "<cmd> Telescope aerial default_selection_index=1 <CR>", { desc = "document functions" })
-- }

map("n", "<leader>fg", "<cmd> Telescope ast_grep<CR>", { desc = "Structural search" })
map("v", "<leader>fg", function()
  require("telescope").extensions.ast_grep.ast_grep {
    default_text = getVisualSelection(),
  }
end, { desc = "Structural search" })
-- }

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
