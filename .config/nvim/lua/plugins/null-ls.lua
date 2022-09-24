return function()
  local null_ls = require('null-ls')

  null_ls.setup({
    debounce = 150,
    sources = {
      null_ls.builtins.formatting.prettier.with({
        condition = function(_utils) return _utils.root_has_file('.prettierrc') end,
      }),
      null_ls.builtins.formatting.stylua.with({
        condition = function(_utils) return gh.executable('stylua') and _utils.root_has_file('stylua.toml') end,
      }),
    },
  })
end
