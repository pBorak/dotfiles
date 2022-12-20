return function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'bash',
      'ruby',
      'lua',
      'css',
      'javascript',
      'typescript',
      'scss',
      'html',
      'tsx',
      'json',
      'yaml',
      'hcl',
      'markdown',
      'markdown_inline',
      'diff',
      'regex',
      'query',
      'vim',
      'help',
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
      },
    },
    indent = {
      enable = true,
      disable = { 'ruby' },
    },
    textobjects = {
      lookahead = true,
      select = {
        enable = true,
        keymaps = {
          ['am'] = '@function.outer',
          ['im'] = '@function.inner',
          ['rc'] = '@rspec.context',
          ['ri'] = '@rspec.it',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']r'] = '@rspec.it',
        },
        goto_previous_start = {
          ['[r'] = '@rspec.it',
        },
      },
    },
    endwise = {
      enable = true,
    },
    autotag = { enable = true },
  })
end
