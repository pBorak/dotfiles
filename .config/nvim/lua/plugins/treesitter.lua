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
          [']m'] = '@function.outer',
          [']r'] = '@rspec.it',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[r'] = '@rspec.it',
        },
      },
      lsp_interop = {
        enable = true,
        border = 'rounded',
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
        },
      },
    },
    endwise = {
      enable = true,
    },
    autotag = { enable = true },
  })
end
