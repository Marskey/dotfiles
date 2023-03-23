local present, neotree = pcall(require, "neo-tree")
if not present then
  return
end

local function copy_to_clipboard(content)
  vim.fn.setreg("*", content)
  vim.fn.setreg("+", content)
  vim.fn.setreg('"', content)
  return vim.notify(string.format("Copied %s to system clipboard!", content))
end

neotree.setup {
  filesystem = {
    commands = {
      copy_file_name = function(state)
        local node = state.tree:get_node()
        copy_to_clipboard(node.name)
      end,
      copy_path = function(state)
        local node = state.tree:get_node()
        local full_path = node.path
        local relative_path = full_path:sub(#state.path + 2)
        copy_to_clipboard(relative_path)
      end,
      copy_absolute_path = function(state)
        local node = state.tree:get_node()
        copy_to_clipboard(node.path)
      end,
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        -- macOs: open file in default application in the background.
        -- Probably you need to adapt the Linux recipe for manage path with spaces. I don't have a mac to try.
        -- Linux: open file in default application
        if vim.fn.has "mac" == 1 or vim.fn.has "macunix" == 1 then
          vim.api.nvim_command("silent !open -R " .. path)
        elseif vim.fn.has "unix" == 1 then
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
        end
      end,
    },
    window = {
      mappings = {
        ["go"] = "system_open",
        ["/"] = "noop",
        ["<space>"] = "",
        ["za"] = { "toggle_node" },
        ["y"] = "copy_file_name",
        ["Y"] = "copy_path",
        ["gy"] = "copy_absolute_path",
        ["C"] = "copy",
        ["c"] = "copy_to_clipboard",
        ["zR"] = "expand_all_nodes",
        ["zm"] = "close_node",
        ["zM"] = "close_all_nodes",
        ["z"] = "",
      },
    },
  },
}
