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

        map('n', '<down>', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gs.nav_hunk('next')
          end
        end)
        map('n', '<up>', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gs.nav_hunk('prev')
          end
        end)
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>gw', gs.stage_buffer)
        map('n', '<leader>gr', gs.reset_buffer)
        map('n', '<leader>go', gs.preview_hunk)
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
    'tpope/vim-abolish',
    event = 'VeryLazy',
  },

  {
    'christoomey/vim-tmux-navigator',
    commit = 'd847ea942a5bb4d4fab6efebc9f30d787fd96e65',
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
    commit = '3c81345c28',
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
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'elanmed/fzf-lua-frecency.nvim',
    },
    cmd = 'FzfLua',
    keys = {
      {
        '<C-p>',
        function()
          require('fzf-lua-frecency').frecency({
            display_score = false,
            cwd_only = true,
            fzf_opts = { ['--no-sort'] = false },
          })
        end,
      },
      { '<leader>fr', '<Cmd>FzfLua resume<CR>' },
      { '<leader>fo', '<Cmd>FzfLua buffers<CR>' },
      { '<leader>fb', '<Cmd>FzfLua git_branches<CR>' },
      { '<leader>fc', '<Cmd>FzfLua git_bcommits<CR>' },
      { '<leader>fs', '<Cmd>FzfLua live_grep<CR>' },
      { '<leader>ff', '<Cmd>FzfLua grep_cword<CR>' },
      { '<leader>ff', '<Cmd>FzfLua grep_visual<CR>', mode = { 'v' } },
      { '<leader>fg', '<Cmd>FzfLua git_status<CR>' },
      { '<leader>ld', '<cmd>FzfLua lsp_definitions<CR>' },
      { '<leader>lr', '<cmd>FzfLua lsp_references<CR>' },
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
      { 'border-fused', 'hide' },
      fzf_colors = true,
      fzf_opts = {
        ['--no-scrollbar'] = true,
      },
      defaults = {
        formatter = 'path.dirname_first',
        git_icons = false,
      },
      winopts = {
        preview = {
          horizontal = 'right:50%',
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
          ['ctrl-q'] = 'select-all+accept',
          ['up'] = 'previous-history',
          ['down'] = 'next-history',
          ['ctrl-p'] = 'up',
          ['ctrl-n'] = 'down',
          ['alt-a'] = 'toggle-all',
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
        fzf_opts = {
          ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-grep-history',
        },
      },
      git = {
        branches = {
          winopts = {
            width = 0.5,
            height = 0.4,
            preview = { hidden = 'hidden' },
          },
          cmd_add = { 'git', 'checkout', '-b' },
        },
      },
    },
    init = function()
      require('fzf-lua').register_ui_select(function(o, items)
        local min_h, max_h = 0.15, 0.70
        local preview = o.kind == 'codeaction' and 0.20 or 0
        local h = (#items + 4) / vim.o.lines + preview
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)
    end,
  },
}
