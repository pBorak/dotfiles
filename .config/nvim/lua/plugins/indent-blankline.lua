return function()
  require('indent_blankline').setup {
    char = '│',
    show_foldtext = false,
    show_current_context = true,
    show_current_context_start = true,
    show_current_context_start_on_current_line = false,
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
