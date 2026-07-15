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

local function ast_grep(opts)
  opts = opts or {}

  if vim.fn.executable "ast-grep" ~= 1 then
    vim.notify("ast-grep executable not found", vim.log.levels.ERROR, { title = "FzfLua ast_grep" })
    return
  end

  local lang = opts.lang or language_by_filetype[vim.bo.filetype]
  if not lang then
    vim.notify(
      ("No ast-grep language is configured for filetype %q; pass lang=<language> to override it"):format(
        vim.bo.filetype
      ),
      vim.log.levels.ERROR,
      { title = "FzfLua ast_grep" }
    )
    return
  end

  local query = opts.search or opts.query or ""
  local cmd = table.concat({
    "ast-grep run",
    "--lang",
    vim.fn.shellescape(lang),
    "--heading never",
    "--color always",
    "--follow",
    "--pattern",
  }, " ")

  opts = vim.tbl_deep_extend("force", {
    cmd = cmd,
    search = query,
    no_esc = true,
    query = query,
    rg_glob = false,
    prompt = ("Ast-grep (%s)> "):format(lang),
    fzf_opts = {
      ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-ast-grep-history",
    },
    actions = {
      ["ctrl-g"] = false,
      ["alt-i"] = false,
      ["alt-h"] = false,
      ["alt-f"] = false,
    },
  }, opts)

  -- Follow fzf-lua's live_grep function-producer path, but keep this as an
  -- independent provider. Running the command through fzf-lua's libuv pipe
  -- also avoids ast-grep being stopped as a native fzf reload child.
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

  opts.__call_fn = ast_grep
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

  opts.query = opts.search or ""
  opts = core.set_title_flags(opts, { "cmd", "live" })
  opts = core.set_fzf_field_index(opts)

  local contents = function(args, picker_opts)
    return require("fzf-lua.make_entry").lgrep(args, picker_opts)
  end

  return core.fzf_live(contents, opts)
end

return ast_grep
