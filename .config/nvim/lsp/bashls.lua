return {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/bash-language-server', 'start' },
  filetypes = { 'bash', 'sh', 'zsh' },
}
