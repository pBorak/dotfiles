return function()
  local null_ls = require 'null-ls'

  null_ls.setup {
    debounce = 150,
    on_attach = gh.lsp.on_attach,
    sources = {
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.formatting.stylua.with {
        condition = function(_utils)
          return gh.executable 'stylua' and _utils.root_has_file 'stylua.toml'
        end,
      },
    },
  }
end
