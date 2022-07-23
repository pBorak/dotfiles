return function()
  require('indent_blankline').setup({
    char = '│',
    context_char = '┃',
    show_current_context = true,
    filetype_exclude = {
      'log',
      'fugitive',
      'gitcommit',
      'packer',
      'markdown',
      'json',
      'txt',
      'help',
      'git',
      'TelescopePrompt',
      'undotree',
      'NvimTree',
      '', -- for all buffers without a file type
    },
    buftype_exclude = { 'terminal', 'nofile' },
  })
end
