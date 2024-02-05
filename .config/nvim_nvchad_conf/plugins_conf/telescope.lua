local entry_display = require "telescope.pickers.entry_display"

local function gen_from_commit(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      { width = 4 },
      { width = 11 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value, "TelescopeResultsIdentifier" },
      { entry.author, "String" },
      { entry.date, "Special" },
      entry.msg,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local sha, author, date, msg = string.match(entry, "([^ ]+) <(.+)> %[(.+)%] (.+)")

    if not msg then
      msg = "<empty commit message>"
    end

    return {
      value = sha,
      ordinal = entry,
      author = author,
      date = date,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }
  end
end

local action_state = require "telescope.actions.state"
local utils = require "telescope.utils"
local actions = require "telescope.actions"
local git_copy_sha = function (prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if selection == nil then
        utils.__warn_no_selection "git_copy_sha"
        return
    end
    actions.close(prompt_bufnr)
    local content = selection.value
    vim.fn.setreg("+", content)
    vim.fn.setreg('"', content)
    vim.notify(string.format("Copied SHA:%s to system clipboard!", content))
end

local options = {
  defaults = {
    -- vimgrep_arguments = {
    --     "rg",
    --     "--json",
    --     "--smart-case",
    -- },
    prompt_prefix = "",
    path_display = { shorten = { len = 3, exclude = { 1, 2, -2, -1 } } },
    history = false,
    cache_picker = {
      num_pickers = 5,
    },
    mappings = {
      i = {
        ["<c-k>"] = "move_selection_previous",
        ["<c-j>"] = "move_selection_next",
        ["<c-n>"] = "cycle_previewers_next",
        ["<c-p>"] = "cycle_previewers_prev",
        ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
        ["<c-s>"] = "select_horizontal",
      },
      n = {
        ["<c-n>"] = "cycle_previewers_next",
        ["<c-p>"] = "cycle_previewers_prev",
        ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
        ["<c-s>"] = "select_horizontal",
      },
    },
    preview = {
      timeout = 500,
    },
    -- layout_strategy = "bottom_pane",
    -- borderchars = {
    --     prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
    --     results = { " " },
    --     preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    -- },
  },
  pickers = {
    -- live_grep = {
    --   entry_index = {
    --     colend = function(t)
    --       return (t["submatches"][1]["end"] + 1) or nil
    --     end,
    --   },
    -- },
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      scroll_strategy = "limit",
    },
    git_bcommits = {
      git_command = {
        "git",
        "log",
        "--pretty=format:%h <%an> [%ch] %s",
        "--abbrev-commit",
        "--follow",
      },
      entry_maker = gen_from_commit(),
      mappings = {
        i = {
          ["<cr>"] = function(...)
            git_copy_sha(...)
          end,
          ["<c-o>"] = "git_checkout_current_buffer"
        },
      },
    },
    git_commits = {
      current_previewer_index = 4,
      git_command = {
        "git",
        "log",
        "--pretty=%h <%an> [%ch] %s",
        "--abbrev-commit",
        "--",
        ".",
      },
      entry_maker = gen_from_commit(),
    },
  },
  extensions_list = { "fzf", "themes", "terms", "live_grep_args", "aerial", "ast_grep" },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    aerial = {
      default_selection_index = 1,
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = {
        ["_"] = false, -- This key will be the default
        json = true, -- You can set the option for specific filetypes
        yaml = true,
      },
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      entry_maker = require("telescope.make_entry").gen_from_vimgrep_json(),
      vimgrep_arguments = {"rg", "--smart-case", "--json"},
      mappings = {
        i = {
          ["<c-i>"] = function(...)
            require("telescope-live-grep-args.actions").quote_prompt()(...)
          end,
        },
      },
    },
  },
}

return options
