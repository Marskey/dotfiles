local language_by_filetype = {
  bash = "bash",
  c = "c",
  cpp = "cpp",
  cs = "csharp",
  css = "css",
  elixir = "elixir",
  go = "go",
  haskell = "haskell",
  hcl = "hcl",
  html = "html",
  java = "java",
  javascript = "javascript",
  javascriptreact = "javascript",
  json = "json",
  jsonc = "json",
  kotlin = "kotlin",
  lua = "lua",
  nix = "nix",
  php = "php",
  python = "python",
  ruby = "ruby",
  rust = "rust",
  scala = "scala",
  sh = "bash",
  solidity = "solidity",
  swift = "swift",
  tsx = "tsx",
  typescript = "typescript",
  typescriptreact = "tsx",
  yaml = "yaml",
  zsh = "bash",
}

local languages = {}
do
  local seen = {}
  for _, language in pairs(language_by_filetype) do
    if not seen[language] then
      seen[language] = true
      languages[#languages + 1] = language
    end
  end
  table.sort(languages)
end

local ast_grep
local ast_grep_fuzzy

local function run_ast_grep(opts)
  opts = opts or {}
  local fuzzy = opts.__ast_grep_fuzzy == true

  if vim.fn.executable "ast-grep" ~= 1 then
    vim.notify("ast-grep executable not found", vim.log.levels.ERROR, { title = "FzfLua ast_grep" })
    return
  end

  local filetype = vim.bo.filetype
  if filetype == "" then
    filetype = vim.filetype.match { buf = 0 } or ""
  end

  local lang = opts.lang or language_by_filetype[filetype]
  if not lang then
    require("fzf-lua.providers.ui_select").ui_select(
      languages,
      { prompt = "Ast-grep language:", kind = "ast_grep_language" },
      function(language)
        if not language then
          return
        end
        opts.lang = language
        ast_grep(opts)
      end
    )
    return
  end

  local cmd = table.concat({
    "ast-grep run",
    "--lang",
    vim.fn.shellescape(lang),
    "--json=stream",
    "--follow",
    "--pattern",
  }, " ")

  local actions = require "fzf-lua.actions"
  opts = vim.tbl_deep_extend("force", {
    cmd = cmd,
    lang = lang,
    no_esc = true,
    rg_glob = false,
    fn_transform = [[return require("pickers.ast_grep_entry").transform]],
    prompt = (fuzzy and "Ast-grep fuzzy (%s)> " or "Ast-grep (%s)> "):format(lang),
    fzf_opts = {
      ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-ast-grep-history",
    },
    actions = {
      ["ctrl-g"] = {
        actions.grep_lgrep,
        header = fuzzy and "Ast-grep Search" or "Fuzzy Search",
      },
      ["alt-i"] = false,
      ["alt-h"] = false,
      ["alt-f"] = false,
    },
  }, opts)

  -- Follow fzf-lua's live_grep function-producer path, but keep this as an
  -- independent provider. JSON stream output preserves one record per AST
  -- match, and the entry transform adapts it to fzf-lua's grep format.
  opts.multiprocess = false
  opts.rg_glob = false

  local config = require "fzf-lua.config"
  local core = require "fzf-lua.core"
  local utils = require "fzf-lua.utils"

  opts = config.normalize_opts(opts, "grep", "ast_grep")
  if not opts then
    return
  end

  if opts._treesitter == 1 then
    utils.map_set(opts, "winopts.treesitter", false)
  end

  local query = opts.search or opts.query or ""
  opts.search = query
  opts.__call_fn = fuzzy and ast_grep_fuzzy or ast_grep
  opts.__ACT_TO = function(toggle_opts)
    toggle_opts.lang = lang
    if fuzzy then
      return ast_grep(toggle_opts)
    end
    return ast_grep_fuzzy(toggle_opts)
  end

  if fuzzy then
    -- In this mode the ast-grep pattern is fixed and the prompt filters its
    -- result set with fzf. Keep fuzzy queries separate from the AST pattern.
    opts.__resume_set = false
    opts.__resume_get = false
    opts.is_live = false
    opts.query = ""
    opts.cmd = ("%s %s"):format(cmd, vim.fn.shellescape(query))
    opts = core.set_title_flags(opts, { "cmd" })
    opts = core.set_fzf_field_index(opts)
    return core.fzf_exec(opts.cmd, opts)
  end

  opts.__resume_set = function(what, value, picker_opts)
    if what == "query" then
      config.resume_set("search", value, { __resume_key = picker_opts.__resume_key })
      config.resume_set("no_esc", true, { __resume_key = picker_opts.__resume_key })
      utils.map_set(config, "__resume_data.last_query", value)
      utils.map_set(config, "__resume_data.opts.query", value)
      picker_opts.last_query = value
    else
      config.resume_set(what, value, { __resume_key = picker_opts.__resume_key })
    end
  end
  opts.__resume_get = function(what, picker_opts)
    return config.resume_get(what == "query" and "search" or what, { __resume_key = picker_opts.__resume_key })
  end

  opts.query = query
  opts = core.set_title_flags(opts, { "cmd", "live" })
  opts = core.set_fzf_field_index(opts)

  local contents = function(args, picker_opts)
    return require("fzf-lua.make_entry").lgrep(args, picker_opts)
  end

  return core.fzf_live(contents, opts)
end

ast_grep = function(opts)
  opts = opts or {}
  opts.__ast_grep_fuzzy = false
  return run_ast_grep(opts)
end

ast_grep_fuzzy = function(opts)
  opts = opts or {}
  opts.__ast_grep_fuzzy = true
  return run_ast_grep(opts)
end

return ast_grep
