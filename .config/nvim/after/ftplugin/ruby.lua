gh.nnoremap('<leader>bp', [[orequire "pry"; binding.pry<esc>]], { buffer = 0 })
vim.opt_local.formatoptions:remove('r')
vim.opt_local.formatoptions:remove('o')
