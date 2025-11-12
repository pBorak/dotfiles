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
      { '<leader>gr', '<cmd>Gread<CR>' },
      { '<leader>gw', '<cmd>Gwrite<CR>' },
    },
  },

  {
    'linrongbin16/gitlinker.nvim',
    opts = function()
      return {
        router = {
          browse = {
            ['^gitlab%.housecalldev%.com'] = require('gitlinker.routers').gitlab_browse,
          },
          blame = {
            ['^gitlab%.housecalldev%.com'] = require('gitlinker.routers').gitlab_blame,
          },
        },
      }
    end,
    keys = {
      { '<leader>xl', '<cmd>GitLink<cr>', mode = { 'n', 'v' } },
      { '<leader>xo', '<cmd>GitLink!<cr>', mode = { 'n', 'v' } },
    },
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<Cmd>DiffviewOpen<CR>' },
      { '<leader>gh', '<Cmd>DiffviewFileHistory<CR>' },
      { '<leader>gh', [[:'<'>DiffviewFileHistory<CR>]], mode = 'v' },
      { '<leader>gp', '<Cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>' },
      {
        '<leader>gP',
        '<Cmd>:DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges<CR>',
      },
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
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      input = { enabled = true },
      notification = {
        wo = { wrap = true },
      },
    },
    keys = {
      { '<leader>N', function() Snacks.notifier.hide() end },
    },
  },

  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    config = true,
  },

  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    lazy = true,
    keys = {
      {
        '<leader>lf',
        function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
      },
      format_on_save = function()
        -- Stop if we disabled auto-formatting.
        if not vim.g.autoformat then return nil end
        return {}
      end,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.g.autoformat = true
    end,
  },
}
