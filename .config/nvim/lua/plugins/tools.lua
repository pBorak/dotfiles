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
    'NeogitOrg/neogit',
    branch = 'nightly',
    cmd = 'Neogit',
    keys = {
      { '<leader>gs', function() require('neogit').open() end },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
    opts = {
      integrations = {
        diffview = true,
        fzf_lua = true,
      },
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
    'NvChad/nvim-colorizer.lua',
    ft = { 'html', 'css', 'sass' },
    config = true,
  },
}
