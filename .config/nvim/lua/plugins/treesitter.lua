return function()
  require('nvim-treesitter.configs').setup {
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
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = '<leader>v', -- maps in normal mode to init the node/scope selection
        node_incremental = '<leader>v', -- increment to the upper named parent
        node_decremental = '<leader>V', -- decrement to the previous node
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
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          [']w'] = '@parameter.inner',
        },
        swap_previous = {
          ['[w'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']b'] = '@block.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[b'] = '@block.outer',
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
  }
end
