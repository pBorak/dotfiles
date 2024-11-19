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
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      dashboard = { enabled = true },
      notification = {
        wo = { wrap = true },
      },
    },
    keys = {
      { '<leader>N', function() Snacks.notifier.hide() end },
      { '<leader>gg', function() Snacks.lazygit() end },
    },
  },
}
