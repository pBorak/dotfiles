vim.keymap.set('n', '<leader>bp', [[obinding.irb<esc>]], { buffer = 0, silent = true })
vim.opt_local.formatoptions:remove('r')
vim.opt_local.formatoptions:remove('o')

vim.keymap.set('n', 'gf', function()
  local line = vim.api.nvim_get_current_line()
  local path = line:match('vcr_cassettes:%s*"(.-)"')

  if path then
    local full_path = 'spec/fixtures/vcr_cassettes/qbo/' .. path .. '.yml'
    vim.cmd('edit ' .. full_path)
  else
    vim.cmd('normal! gf')
  end
end, { buffer = true })
