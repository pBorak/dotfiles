return function()
  require('noice').setup({
    views = {
      mini = {
        focusable = false,
      },
    },
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
  })
end
