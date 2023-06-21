return {

  {
    'stevearc/oil.nvim',
    keys = {
      { '-', '<cmd>Oil<cr>' },
    },
    opts = {
      keymaps = {
        ['q'] = 'actions.close',
        ['<C-p>'] = false,
        ['<C-h>'] = false,
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
            preview = 'git show --color=always {1} | delta  --width=$FZF_PREVIEW_COLUMNS',
          })
        end,
      },
      { '<leader>f.', function() require('fzf-lua').files({ cwd = '%:h' }) end },
      { '<leader>fd', function() require('fzf-lua').files({ cwd = vim.env.DOTFILES }) end },
    },
    opts = {
      fzf_opts = {
        ['--no-scrollbar'] = '',
        ['--ellipsis'] = '…',
      },
      fzf_colors = {
        ['fg'] = { 'fg', 'Normal' },
        ['bg'] = { 'bg', 'Normal' },
        ['hl'] = { 'fg', 'Special' },
        ['fg+'] = { 'fg', 'Visual' },
        ['bg+'] = { 'bg', 'Visual' },
        ['hl+'] = { 'fg', 'Special' },
        ['info'] = { 'fg', 'Comment', 'italic' },
        ['prompt'] = { 'fg', 'Special' },
        ['pointer'] = { 'fg', 'Visual' },
        ['marker'] = { 'fg', 'MatchParen' },
        ['spinner'] = { 'fg', 'Normal' },
        ['header'] = { 'fg', 'Visual' },
        ['gutter'] = { 'bg', 'Normal' },
      },
      file_icon_padding = ' ',
      winopts = {
        preview = {
          vertical = 'up:45%',
          horizontal = 'right:50%',
        },
        width = 0.7,
        height = 0.7,
        hl = { border = 'FloatBorder' },
      },
      keymap = {
        builtin = {
          ['<c-f>'] = 'preview-page-down',
          ['<c-b>'] = 'preview-page-up',
        },
        fzf = {
          ['esc'] = 'abort',
          ['ctrl-l'] = 'select-all+accept',
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
      },
      git = {
        files = {
          git_icons = false,
          cmd = 'git ls-files -o -c --exclude-standard',
        },
        branches = {
          winopts = {
            width = 0.5,
            height = 0.4,
            preview = { hidden = 'hidden' },
          },
        },
        status = { preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS' },
        bcommits = { preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS' },
        commits = { preview_pager = 'delta --width=$FZF_PREVIEW_COLUMNS' },
      },
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require('flash').jump()
        end,
      },
      {
        'S',
        mode = { 'o', 'x' },
        function() require('flash').treesitter() end,
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '▌' },
        change = { text = '▌' },
        delete = { text = '▌' },
        topdelete = { text = '▌' },
        changedelete = { text = '▌' },
        untracked = { text = '▍' },
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
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hl', function() gs.setqflist('all') end)
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
    config = function()
      vim.keymap.set('n', '<localleader>m', require('harpoon.mark').add_file)
      vim.keymap.set('n', '<localleader><localleader>', require('harpoon.ui').toggle_quick_menu)

      vim.keymap.set(
        'n',
        '<localleader>a',
        '<cmd>lua require("harpoon.ui").nav_file(1)<cr>',
        { silent = true }
      )
      vim.keymap.set(
        'n',
        '<localleader>s',
        '<cmd>lua require("harpoon.ui").nav_file(2)<cr>',
        { silent = true }
      )
      vim.keymap.set(
        'n',
        '<localleader>d',
        ':lua require("harpoon.ui").nav_file(3)<cr>',
        { silent = true }
      )
      vim.keymap.set(
        'n',
        '<localleader>f',
        '<cmd>lua require("harpoon.ui").nav_file(4)<cr>',
        { silent = true }
      )
    end,
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = { preview = { auto_preview = false } },
  },

  {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
      { 'olimorris/neotest-rspec' },
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
          require('neotest-rspec')({
            rspec_cmd = './neotest_docker_script.sh',
          }),
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
