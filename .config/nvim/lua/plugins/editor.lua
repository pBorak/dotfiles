return {

  {
    'stevearc/oil.nvim',
    lazy = false,
    keys = {
      { '-', '<cmd>Oil<cr>' },
    },
    opts = {
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ['q'] = 'actions.close',
        ['<C-p>'] = false,
        ['<C-h>'] = false,
        ['<C-l>'] = false,
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      { '<c-p>', '<Cmd>FzfLua git_files<CR>' },
      { '<leader>fr', '<Cmd>FzfLua resume<CR>' },
      { '<leader>fo', '<Cmd>FzfLua buffers<CR>' },
      { '<leader>fb', '<Cmd>FzfLua git_branches<CR>' },
      { '<leader>fc', '<Cmd>FzfLua git_bcommits<CR>' },
      { '<leader>fs', '<Cmd>FzfLua live_grep<CR>' },
      { '<leader>ff', '<Cmd>FzfLua grep_cword<CR>' },
      { '<leader>ff', '<Cmd>FzfLua grep_visual<CR>', mode = { 'v' } },
      { '<leader>fg', '<Cmd>FzfLua git_status<CR>' },
      {
        '<leader>fG',
        function()
          require('fzf-lua').fzf_live('git log --oneline --color=always -S <query>', {
            fzf_opts = {
              ['--no-sort'] = '',
            },
            preview = 'git show --color=always {1} | delta',
            actions = {
              ['default'] = function(selected) vim.cmd('Gedit ' .. selected[1]:match('[^ ]+')) end,
            },
          })
        end,
      },
      { '<leader>f.', function() require('fzf-lua').files({ cwd = '%:h' }) end },
      { '<leader>fd', function() require('fzf-lua').files({ cwd = vim.env.DOTFILES }) end },
    },
    opts = {
      'default-title',
      fzf_colors = true,
      fzf_opts = {
        ['--no-scrollbar'] = true,
      },
      defaults = {
        formatter = 'path.dirname_first',
      },
      winopts = {
        preview = {
          horizontal = 'right:50%',
          scrollchars = { '┃', '' },
        },
        width = 0.8,
        height = 0.8,
        row = 0.5,
        col = 0.5,
      },
      keymap = {
        builtin = {
          ['<c-f>'] = 'preview-page-down',
          ['<c-b>'] = 'preview-page-up',
        },
        fzf = {
          ['esc'] = 'abort',
          ['ctrl-l'] = 'select-all+accept',
          ['ctrl-j'] = 'previous-history',
          ['ctrl-k'] = 'next-history',
          ['ctrl-p'] = 'up',
          ['ctrl-n'] = 'down',
        },
      },
      buffers = {
        winopts = {
          width = 0.5,
          height = 0.4,
          preview = { hidden = 'hidden' },
        },
      },
      grep = {
        git_icons = false,
        rg_glob = true,
        rg_opts = [[--hidden --column --line-number --no-heading]]
          .. [[ --color=always --smart-case -g "!.git" -e]],
        fzf_opts = {
          ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-grep-history',
        },
      },
      git = {
        files = {
          git_icons = false,
          cmd = 'git ls-files -o -c --exclude-standard',
          fzf_opts = {
            ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-gitfiles-history',
          },
        },
        branches = {
          winopts = {
            width = 0.5,
            height = 0.4,
            preview = { hidden = 'hidden' },
          },
          cmd_add = { 'git', 'checkout', '-b' },
        },
        status = { preview_pager = 'delta' },
        bcommits = { preview_pager = 'delta' },
        commits = { preview_pager = 'delta' },
      },
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        char = {
          keys = { 'f', 'F', 't', 'T' },
        },
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require('flash').jump()
        end,
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r) vim.keymap.set(mode, l, r, { buffer = buffer }) end

        map('n', ']g', gs.next_hunk)
        map('n', '[g', gs.prev_hunk)
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>gw', gs.stage_buffer)
        map('n', '<leader>gr', gs.reset_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hp', gs.preview_hunk_inline)
      end,
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'BufReadPost',
    config = true,
  },

  {
    'tpope/vim-projectionist',
    config = function() vim.keymap.set('n', '<leader>a', '<cmd>A<cr>') end,
  },

  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<c-h>', '<cmd>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd>TmuxNavigateRight<cr>' },
    },
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },

  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({
        settings = {
          save_on_toggle = true,
        },
      })
      vim.keymap.set('n', '<localleader>m', function() harpoon:list():add() end)
      vim.keymap.set(
        'n',
        '<localleader><localleader>',
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end
      )

      vim.keymap.set('n', '<localleader>a', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<localleader>s', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<localleader>d', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<localleader>f', function() harpoon:list():select(4) end)
    end,
  },

  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    keys = {
      {
        '<leader>cc',
        function() require('quicker').toggle() end,
      },
    },
    opts = {
      keys = {
        {
          '>',
          function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
        },
        {
          '<',
          function() require('quicker').collapse() end,
        },
      },
    },
  },

  {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
      { 'olimorris/neotest-rspec' },
      { 'nvim-neotest/nvim-nio' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    keys = {
      {
        '<leader>to',
        function() require('neotest').output.open({ enter = true, short = false }) end,
      },
      { '<leader>tt', function() require('neotest').run.run() end },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end },
      { '<leader>tl', function() require('neotest').run.run_last() end },
      { '<leader>ta', function() require('neotest').run.attach() end },
      { ']t', function() require('neotest').jump.next({ status = 'failed' }) end },
      { '[t', function() require('neotest').jump.prev({ status = 'failed' }) end },
    },
    opts = function()
      return {
        discovery = {
          enabled = false,
        },
        diagnostic = {
          enabled = true,
        },
        adapters = {
          require('neotest-rspec')({ rspec_cmd = 'bin/rspec' }),
        },
        icons = {
          expanded = '',
          child_prefix = '',
          child_indent = '',
          final_child_prefix = '',
          non_collapsible = '',
          collapsed = '',
          passed = '',
          running = '',
          failed = '',
          unknown = '',
          skipped = '',
        },
        quickfix = {
          enabled = false,
          open = false,
        },
        floating = {
          border = 'single',
          max_height = 0.8,
          max_width = 0.9,
        },
      }
    end,
  },
}
