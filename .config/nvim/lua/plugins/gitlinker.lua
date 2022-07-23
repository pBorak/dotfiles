return function()
  local linker = require('gitlinker')
  linker.setup({ mappings = '<leader>xl' })
  local callback = { action_callback = require('gitlinker.actions').open_in_browser }
  gh.nnoremap('<leader>xo', function() linker.get_buf_range_url('n', callback) end)
  gh.vnoremap('<leader>xo', function() linker.get_buf_range_url('v', callback) end)
end
