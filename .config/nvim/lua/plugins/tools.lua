return {

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
    'esmuellert/codediff.nvim',
    keys = {
      { '<leader>gd', '<Cmd>CodeDiff<CR>' },
      { '<leader>gh', '<Cmd>CodeDiff history<CR>' },
    },
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    opts = {
      keymaps = {
        view = {
          quit = 'q',
          toggle_explorer = '<leader>b',
          next_hunk = '<down>',
          prev_hunk = '<up>',
          next_file = '<tab>',
          prev_file = '<s-tab>',
          open_in_prev_tab = 'gf',
          toggle_stage = '-',
        },
        explorer = {
          select = '<CR>',
          hover = 'K',
          toggle_view_mode = 'i', -- Toggle between 'list' and 'tree' views
          stage_all = 'S',
          unstage_all = 'U',
          restore = 'X',
        },
        history = {
          select = '<CR>',
          toggle_view_mode = 'i',
        },
        conflict = {
          accept_incoming = '<leader>ct',
          accept_current = '<leader>co',
          accept_both = '<leader>cb',
          discard = '<leader>cx',
          next_conflict = ']x',
          prev_conflict = '[x',
          diffget_incoming = '2do',
          diffget_current = '3do',
        },
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
      picker = {
        formatters = {
          file = {
            truncate = 80,
          },
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              ['<c-j>'] = { 'history_forward', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'history_back', mode = { 'i', 'n' } },
              ['<a-q>'] = { 'select_all', mode = { 'n', 'i' } },
              -- Terminal-like line editing (readline bindings)
              ['<c-a>'] = { '<Home>', mode = { 'i' }, expr = true },
              ['<c-e>'] = { '<End>', mode = { 'i' }, expr = true },
              ['<c-u>'] = { '<c-s-u>', mode = { 'i' }, expr = true },
            },
          },
        },
        sources = {
          files = {
            hidden = true,
          },
          grep = {
            win = {
              input = {
                keys = {
                  ['<C-o>'] = {
                    function() vim.api.nvim_feedkeys(' -- -g ', 'n', false) end,
                    mode = { 'i' },
                  },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      { '<leader>N', function() Snacks.notifier.hide() end },
      { '<c-p>', function() Snacks.picker.files() end },
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
