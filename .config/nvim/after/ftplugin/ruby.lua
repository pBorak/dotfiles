vim.keymap.set(
  'n',
  '<leader>bp',
  [[orequire "pry"; binding.pry<esc>]],
  { buffer = 0, silent = true }
)
vim.opt_local.formatoptions:remove('r')
vim.opt_local.formatoptions:remove('o')
