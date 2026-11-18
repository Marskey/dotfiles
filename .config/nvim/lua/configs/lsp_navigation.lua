local M = {}
local definition_request = 0

function M.definition()
  definition_request = definition_request + 1
  local request = definition_request
  local win = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)

  vim.lsp.buf.definition {
    on_list = function(list)
      -- Ignore superseded responses and responses for a call site we have left or edited.
      if
        request ~= definition_request
        or not vim.api.nvim_win_is_valid(win)
        or vim.api.nvim_get_current_win() ~= win
        or vim.api.nvim_win_get_buf(win) ~= bufnr
        or vim.api.nvim_buf_get_changedtick(bufnr) ~= changedtick
        or not vim.deep_equal(vim.api.nvim_win_get_cursor(win), cursor)
      then
        return
      end

      if #list.items == 1 then
        local item = list.items[1]
        -- Neovim has already converted each client's result to byte columns.
        local position = { line = item.lnum - 1, character = item.col - 1 }
        if
          vim.lsp.util.show_document({
            uri = vim.uri_from_fname(item.filename),
            range = { start = position, ["end"] = position },
          }, "utf-8", { focus = true })
        then
          vim.cmd "normal! zz"
        end
      else
        vim.fn.setqflist({}, " ", list)
        vim.cmd "botright copen"
      end
    end,
  }
end

return M
