local present, toggleterm = pcall(require, "toggleterm")
if not present then
  return
end

toggleterm.setup {
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  autochdir = true,
  -- shade_terminals = true,
  -- shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    winblend = 0,
  },
  highlights = {
    FloatBorder = {
      link = "LineNr",
    },
  },
}
