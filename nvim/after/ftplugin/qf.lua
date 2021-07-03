vim.cmd [[ set signcolumn=yes ]]

gh.nnoremap('>', '<cmd>cnewer<CR>', { buffer = 0 })
gh.nnoremap('<', '<cmd>colder<CR>', { buffer = 0 })
