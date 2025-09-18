return {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
}
