vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(
    string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'),
    vim.log.levels.INFO
  )
end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })

vim.api.nvim_create_user_command(
  'LspInfo',
  function() vim.cmd.checkhealth('vim.lsp') end,
  { desc = 'Show LSP info', nargs = 0 }
)
