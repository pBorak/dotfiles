return function()
  vim.g['test#strategy'] = 'toggleterm'
  gh.nnoremap('<leader>tf', '<cmd>TestFile<CR>')
  gh.nnoremap('<leader>tl', '<cmd>TestLast<CR>')
  gh.nnoremap('<leader>tt', '<cmd>TestNearest<CR>')
  gh.nnoremap('<leader>ta', '<cmd>TestSuite<CR>')
end
