return function()
  require('window-picker').setup({
    autoselect_one = true,
    include_current = false,
    filter_rules = {
      bo = {
        filetype = { 'neo-tree-popup', 'quickfix', 'fugitive' },
        buftype = { 'terminal', 'quickfix', 'nofile' },
      },
    },
  })
end
