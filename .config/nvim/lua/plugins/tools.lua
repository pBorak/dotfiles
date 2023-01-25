return {

  {
    'akinsho/toggleterm.nvim',
    version = '2.*',
    event = 'BufReadPre',
    opts = {
      open_mapping = [[<c-\>]],
      shade_filetypes = { 'none' },
      direction = 'horizontal',
      start_in_insert = true,
      persist_mode = true,
      float_opts = {
        border = 'curved',
        height = function() return math.floor(vim.o.lines * 0.6) end,
        width = function() return math.floor(vim.o.columns * 0.7) end,
      },
      size = function(term)
        if term.direction == 'horizontal' then
          return 35
        elseif term.direction == 'vertical' then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
    },
  },

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
    opts = {
      mappings = '<leader>xl',
    },
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
