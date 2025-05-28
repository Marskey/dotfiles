local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- local loading = nil
--
-- vim.keymap.set("n", "gd", function()
--   if loading then
--     pcall(function()
--       loading:close()
--     end)
--   end
--
--   vim.lsp.buf.definition()
--
--   local clients = vim.lsp.get_clients { { bufnr = 0 } }
--   if not vim.tbl_isempty(clients) then
--     loading = vim.defer_fn(function()
--       local _, winid = vim.lsp.util.open_floating_preview({ "Loading..." }, "markdown", {
--         border = "single",
--         focus = false,
--       })
--       vim.w[winid].lsp_loading_win = "def_req"
--     end, 500)
--   end
-- end, { noremap = true, silent = true })
--
-- local location_handler = vim.lsp.handlers["textDocument/definition"]
-- vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
--   if loading then
--     pcall(function()
--       loading:close()
--     end)
--   end
--
--   for _, id in ipairs(vim.api.nvim_list_wins()) do
--     if "def_req" == vim.w[id].lsp_loading_win then
--       pcall(vim.api.nvim_win_close, id, true)
--     end
--   end
--
--   local posParam = vim.lsp.util.make_position_params()
--   if
--     posParam.textDocument.uri == ctx.params.textDocument.uri
--     and posParam.position.character == ctx.params.position.character
--     and posParam.position.line == ctx.params.position.line
--   then
--     if result == nil or vim.tbl_isempty(result) then
--       vim.lsp.util.open_floating_preview({ "No location found!" }, "markdown", {
--         border = "single",
--         focus = false,
--       })
--     else
--       location_handler(err, result, ctx, config)
--       vim.cmd ":normal! zz"
--     end
--   end
-- end
