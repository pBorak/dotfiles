return {

  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = 'BufReadPost',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
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
        'gitcommit',
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
    },
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
  },

  { 'RRethy/nvim-treesitter-endwise', event = 'BufReadPre' },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    config = function()
      require('treesitter-context').setup({
        patterns = {
          ruby = {
            'block',
          },
        },
      })
    end,
  },

  { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },

  {
    'ckolkey/ts-node-action',
    keys = { { 'K', '<cmd>NodeAction<cr>' } },
    config = true,
  },
}
