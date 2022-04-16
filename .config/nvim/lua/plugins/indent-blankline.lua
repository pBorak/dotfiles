return function()
  require('indent_blankline').setup {
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
    context_patterns = {
      'class',
      'function',
      'method',
      'block',
      'list_literal',
      'selector',
      '^if',
      '^table',
      'if_statement',
      'while',
      'for',
    },
  }
end
