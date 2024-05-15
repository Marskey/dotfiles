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
  -- log_level = "trace", -- "trace", "debug", "info", "warn", "error", "fatal"
  -- log_to_file = true, -- true, false, "/path/to/file.log", use :NeoTreeLogs to show the file
  -- enable_modified_markers = false, -- Show markers for files with unsaved changes.
  -- enable_git_status = false,
  use_libuv_file_watcher = true,
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
        ["c"] = "copy",
        ["C"] = "copy_to_clipboard",
        ["zR"] = "expand_all_nodes",
        ["zr"] = function(state)
          local node = state.tree:get_node()
          local filesystem_commands = require "neo-tree.sources.filesystem.commands"
          filesystem_commands.expand_all_nodes(state, node)
        end,
        ["zm"] = "close_node",
        ["zM"] = "close_all_nodes",
        ["z"] = "",
        ["h"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        ["l"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if not node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            elseif node:has_children() then
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        end,
      },
    },
  },
  event_handlers = {
    {
      event = "neo_tree_popup_input_ready",
      handler = function()
        -- enter input popup with normal mode by default.
        vim.cmd "stopinsert"
      end,
    },
    {
      event = "neo_tree_popup_input_ready",
      ---@param args { bufnr: integer, winid: integer }
      handler = function(args)
        -- map <esc> to enter normal mode (by default closes prompt)
        -- don't forget `opts.buffer` to specify the buffer of the popup.
        vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
      end,
    },
  },
}
