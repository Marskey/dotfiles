local M = {}

function M.transform(line, opts)
  local ok, match = pcall(vim.json.decode, line)
  if not ok or type(match) ~= "table" then
    return line
  end

  local start = match.range and match.range.start
  if type(match.file) ~= "string" or type(start) ~= "table" then
    return line
  end

  local row = tonumber(start.line)
  local col = tonumber(start.column)
  if not row or not col then
    return line
  end

  local text = type(match.text) == "string" and match.text or ""
  local first_line = text:match "^[^\r\n]*" or ""
  local entry = ("%s:%d:%d:%s"):format(match.file, row + 1, col + 1, first_line)

  return require("fzf-lua.make_entry").file(entry, opts)
end

return M
