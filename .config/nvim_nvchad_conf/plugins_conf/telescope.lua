local entry_display = require "telescope.pickers.entry_display"
local make_entry = require "telescope.make_entry"
local utils = require "telescope.utils"
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"

local my_make_entry = {}
my_make_entry.gen_from_commit = function(opts)
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

local function get_path_and_tail(filename)
  local bufname_tail = utils.path_tail(filename)
  local path_without_tail = require("plenary.strings").truncate(filename, #filename - #bufname_tail - 1, "")
  local path_to_display = utils.transform_path({}, path_without_tail)

  return bufname_tail, path_to_display
end

do
  local _entry_make = make_entry.gen_from_file()
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = nil },
      { width = nil },
      { remaining = true },
    },
  }

  my_make_entry.gen_from_file = function(line)
    local entry = _entry_make(line)
    entry.display = function(et)
      -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/make_entry.lua
      local tail_raw, path_to_display = get_path_and_tail(et.value)
      local tail = tail_raw
      local icon, iconhl = utils.get_devicons(tail_raw)

      return displayer {
        { icon, iconhl },
        tail,
        { path_to_display, "TelescopeResultsComment" },
      }
    end
    return entry
  end
end

do
  local _entry_make = make_entry.gen_from_buffer()
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 4 },
      { width = nil },
      { width = nil },
      { remaining = true },
    },
  }

  my_make_entry.gen_from_buffer = function(line)
    local entry = _entry_make(line)
    entry.display = function(et)
      local tail_raw, path_to_display = get_path_and_tail(et.filename)
      local tail = tail_raw
      local icon, iconhl = utils.get_devicons(tail_raw)
      return displayer {
        { et.indicator, "TelescopeResultsComment" },
        { icon, iconhl },
        tail,
        { path_to_display, "TelescopeResultsComment" },
      }
    end
    return entry
  end
end

do
  if make_entry.gen_from_vimgrep_json then
    local _grep_entry_make = make_entry.gen_from_vimgrep_json()
    local displayer = entry_display.create {
      separator = " ",
      items = {
        { width = nil },
        { width = nil },
        { width = nil },
        { remaining = true },
      },
    }
    my_make_entry.gen_from_vimgrep_json = function(line)
      local entry = _grep_entry_make(line)
      if not entry then
        return
      end

      entry.display = function(et)
        -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/make_entry.lua
        local tail_raw, path_to_display = get_path_and_tail(et.filename)
        local icon, iconhl = utils.get_devicons(tail_raw)

        local coordinates = ":"
        if et.lnum then
          if et.col then
            coordinates = string.format(":%s:%s", et.lnum, et.col)
          else
            coordinates = string.format(":%s", et.lnum)
          end
        end
        local tail = tail_raw .. coordinates

        local trimedText = et.text:gsub("^%s*", "")
        local offset = #et.text - #trimedText

        return displayer {
          { icon, iconhl },
          tail,
          { path_to_display, "TelescopeResultsComment" },
          {
            trimedText,
            function()
              local match_hi = "TelescopeMatching"
              local highlights = {}
              for _, submatch in ipairs(et.submatches) do
                table.insert(highlights, { { submatch["start"] - offset, submatch["end"] - offset }, match_hi })
              end
              return highlights
            end,
          },
        }
      end
      return entry
    end
  end
end

local git_copy_sha = function(prompt_bufnr)
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
    -- path_display = { shorten = { len = 3, exclude = { 1, 2, -2, -1 } } },
    path_display = { "absolute" },
    history = false,
    cache_picker = {
      num_pickers = 10,
    },
    mappings = {
      i = {
        ["<c-k>"] = "move_selection_previous",
        ["<c-j>"] = "move_selection_next",
        ["<c-n>"] = "cycle_previewers_next",
        ["<c-p>"] = "cycle_previewers_prev",
        ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
        ["<c-s>"] = "select_horizontal",
        ["<c-q>"] = require("telescope.actions").smart_send_to_loclist + require("telescope.actions").open_loclist,
      },
      n = {
        ["<c-n>"] = "cycle_previewers_next",
        ["<c-p>"] = "cycle_previewers_prev",
        ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
        ["<c-s>"] = "select_horizontal",
        ["<c-q>"] = require("telescope.actions").smart_send_to_loclist + require("telescope.actions").open_loclist,
      },
    },
    preview = {
      timeout = 500,
    },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.45,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    -- layout_strategy = "bottom_pane",
    -- borderchars = {
    --   prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
    --   results = { " " },
    --   preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    -- },
  },
  pickers = {
    find_files = {
      entry_maker = my_make_entry.gen_from_file,
      follow = true,
    },
    oldfiles = {
      cwd_only = true,
      entry_maker = my_make_entry.gen_from_file,
    },
    live_grep = {
      entry_maker = my_make_entry.gen_from_vimgrep_json,
      attach_mappings = function(_, map)
        map("i", "<c-f>", actions.to_fuzzy_refine)
        return true
      end,
    },
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      scroll_strategy = "limit",
      entry_maker = my_make_entry.gen_from_buffer,
    },
    git_bcommits = {
      git_command = {
        "git",
        "log",
        "--pretty=format:%h <%an> [%ch] %s",
        "--abbrev-commit",
        "--follow",
      },
      entry_maker = my_make_entry.gen_from_commit(),
      mappings = {
        i = {
          ["<cr>"] = function(...)
            git_copy_sha(...)
          end,
          ["<c-o>"] = "git_checkout_current_buffer",
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
      entry_maker = my_make_entry.gen_from_commit(),
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
      entry_maker = my_make_entry.gen_from_vimgrep_json,
      vimgrep_arguments = { "rg", "--smart-case", "--json" },
      mappings = {
        i = {
          ["<c-i>"] = function(...)
            require("telescope-live-grep-args.actions").quote_prompt()(...)
          end,
        },
      },
    },
    ast_grep = {
      attach_mappings = function(_, map)
        map("i", "<c-f>", actions.to_fuzzy_refine)
        return true
      end,
    },
  },
}

return options
