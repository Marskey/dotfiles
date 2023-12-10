local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  -- b.formatting.deno_fmt,
  -- b.formatting.prettier,

  -- Lua
  -- b.formatting.lua_format,

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

  -- python
  b.formatting.black.with {
    extra_args = { "--line-length=79" },
  },
  b.formatting.reorder_python_imports,

  -- html
  b.formatting.htmlbeautifier.with {
    extra_args = { "--indent-size=2" },
  },

  -- json
  b.formatting.jq,
}

null_ls.setup {
  debug = false,
  sources = sources,
}
