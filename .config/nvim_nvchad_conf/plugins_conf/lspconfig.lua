-- custom.plugins.lspconfig
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconf = require "lspconfig"
local servers = { "lua_ls", "clangd" }

for _, server in ipairs(servers) do
	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "custom.plugins_conf.lspconfig." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end

	if server == "lua_ls" then
		opts.root_dir = lspconf.util.root_pattern(".luarc.json", ".git")
	end

	lspconf[server].setup(opts)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
})

local location_handler = vim.lsp.handlers["textDocument/definition"]
vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
	if result == nil or vim.tbl_isempty(result) then
		local posParam = vim.lsp.util.make_position_params()
		if
			posParam.textDocument.uri == ctx.params.textDocument.uri
			and posParam.position.character == ctx.params.position.character
			and posParam.position.line == ctx.params.position.line
		then
			vim.lsp.util.open_floating_preview({ "No location found!" }, "markdown", {
				border = "single",
				focus = false,
			})
		end
		return nil
	end

	location_handler(err, result, ctx, config)
    vim.cmd ":normal! zz"
end
