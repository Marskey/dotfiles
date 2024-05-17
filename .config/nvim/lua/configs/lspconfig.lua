local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local status_ok, mason_lsp = pcall(require, "mason-lspconfig")
if status_ok then
  local lspconf = require "lspconfig"

  mason_lsp.setup_handlers {
    function(server_name)
      local opts = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
      }

      local has_custom_opts, server_custom_opts = pcall(require, "custom.plugins_conf.lspconfig." .. server_name)
      if has_custom_opts then
        opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
      end

      lspconf[server_name].setup(opts)
    end,
  }
end

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = "single",
-- })
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = "single",
-- })

local loading = nil

vim.keymap.set("n", "gd", function()
  if loading then
    pcall(function()
      loading:close()
    end)
  end

  vim.lsp.buf.definition()

  local clients = vim.lsp.buf_get_clients(0)
  if not vim.tbl_isempty(clients) then
    loading = vim.defer_fn(function()
      local _, winid = vim.lsp.util.open_floating_preview({ "Loading..." }, "markdown", {
        -- border = "single",
        focus = false,
      })
      vim.w[winid].lsp_loading_win = "def_req"
    end, 500)
  end
end, { noremap = true, silent = true })

local location_handler = vim.lsp.handlers["textDocument/definition"]
vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
  if loading then
    pcall(function()
      loading:close()
    end)
  end

  for _, id in ipairs(vim.api.nvim_list_wins()) do
    if "def_req" == vim.w[id].lsp_loading_win then
      pcall(vim.api.nvim_win_close, id, true)
    end
  end

  local posParam = vim.lsp.util.make_position_params()
  if
    posParam.textDocument.uri == ctx.params.textDocument.uri
    and posParam.position.character == ctx.params.position.character
    and posParam.position.line == ctx.params.position.line
  then
    if result == nil or vim.tbl_isempty(result) then
      vim.lsp.util.open_floating_preview({ "No location found!" }, "markdown", {
        -- border = "single",
        focus = false,
      })
    else
      location_handler(err, result, ctx, config)
      vim.cmd ":normal! zz"
    end
  end
end