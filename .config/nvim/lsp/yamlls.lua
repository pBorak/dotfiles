return {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
}
