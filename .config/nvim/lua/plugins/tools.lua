return {

  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', '<cmd>UndotreeToggle<CR>' } },
    config = function()
      vim.g.undotree_TreeNodeShape = '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'Gedit', 'Gwrite', 'Gread', 'G' },
    event = 'BufReadPre',
    keys = {
      { '<leader>gs', '<cmd>G<CR>' },
      { '<leader>gb', '<cmd>G blame<CR>' },
    },
  },

  {
    'ruifm/gitlinker.nvim',
    keys = {
      {
        '<leader>xl',
        function() require('gitlinker').get_buf_range_url() end,
        mode = { 'n', 'v' },
      },
      {
        '<leader>xo',
        function()
          require('gitlinker').get_buf_range_url(
            'n',
            { action_callback = require('gitlinker.actions').open_in_browser }
          )
        end,
      },
    },
    opts = function()
      return {
        mappings = '<leader>xl',
        callbacks = {
          ['gitlab.housecalldev.com'] = require('gitlinker.hosts').get_gitlab_type_url,
        },
      }
    end,
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<Cmd>DiffviewOpen<CR>' },
      { '<leader>gh', '<Cmd>DiffviewFileHistory<CR>' },
      { '<leader>gh', [[:'<'>DiffviewFileHistory<CR>]], mode = 'v' },
    },
    opts = {
      default_args = {
        DiffviewFileHistory = { '%' },
      },
      enhanced_diff_hl = true,
      keymaps = {
        view = { q = '<Cmd>DiffviewClose<CR>' },
        file_panel = { q = '<Cmd>DiffviewClose<CR>' },
        file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
      },
    },
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      scope = { enabled = true },
      indent = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      input = { enabled = true },
      notification = {
        wo = { wrap = true },
      },
      picker = {
        formatters = {
          file = {
            truncate = 80,
          },
        },
        win = {
          input = {
            keys = {
              ['<c-j>'] = { 'history_forward', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'history_back', mode = { 'i', 'n' } },
            },
          },
        },
      },
    },
    keys = {
      { '<leader>N', function() Snacks.notifier.hide() end },
      { '<c-p>', function() Snacks.picker.files() end },
      { '<leader>fa', function() Snacks.picker.smart() end },
      { '<leader>fr', function() Snacks.picker.resume() end },
      { '<leader>fo', function() Snacks.picker.buffers() end },
      { '<leader>fs', function() Snacks.picker.grep() end },
      { '<leader>ff', function() Snacks.picker.grep_word() end, mode = { 'n', 'x' } },
      { '<leader>f.', function() Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') }) end },
      { '<leader>fd', function() Snacks.picker.files({ cwd = vim.env.DOTFILES }) end },
      { '<leader>fu', function() Snacks.picker.undo() end },
      { '<leader>fg', function() Snacks.picker.git_status() end },
      { '<leader>fb', function() Snacks.picker.git_branches() end },
      { '<leader>ld', function() Snacks.picker.lsp_definitions() end },
      {
        '<leader>lr',
        function() Snacks.picker.lsp_references() end,
        nowait = true,
      },
    },
  },
}
