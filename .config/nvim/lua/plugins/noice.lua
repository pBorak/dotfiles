return function()
  require('noice').setup({
    routes = {
      {
        filter = { event = 'msg_show', kind = '', find = 'written' },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'notify',
          find = 'Format request failed, no matching language servers.',
        },
        opts = { skip = true },
      },
    },
    lsp = {
      signature = {
        enabled = false,
      },
    },
    presets = {
      lsp_doc_border = true,
    },
  })
end
