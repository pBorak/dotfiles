return function()
  vim.cmd([[
    function! ToggleTermStrategy(cmd) abort
      call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
    endfunction

    let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
  ]])

  vim.g['test#strategy'] = 'toggleterm'
  gh.nnoremap('<leader>tf', '<cmd>TestFile<CR>')
  gh.nnoremap('<leader>tl', '<cmd>TestLast<CR>')
  gh.nnoremap('<leader>tt', '<cmd>TestNearest<CR>')
  gh.nnoremap('<leader>ta', '<cmd>TestSuite<CR>')
end
