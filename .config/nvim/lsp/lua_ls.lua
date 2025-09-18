return {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      format = { enable = false },
      completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
      diagnostics = {
        globals = { 'vim' },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
