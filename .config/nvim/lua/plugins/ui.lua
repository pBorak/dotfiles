return {

  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({
        stages = 'static',
        timeout = 3000,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
        on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
      })
      vim.notify = notify

      vim.keymap.set('n', '<leader>N', notify.dismiss, { silent = true })
    end,
  },

  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        ---@diagnostic disable-next-line
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        ---@diagnostic disable-next-line
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function()
      local icons = require('config.icons')

      return {
        options = {
          theme = 'auto',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          icons_enabled = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            {
              'b:gitsigns_head',
              icon = icons.misc.git_branch,
              color = {
                gui = 'bold',
              },
            },
          },
          lualine_c = {
            {
              'filetype',
              icon_only = true,
              padding = { left = 1, right = 0 },
            },
            {
              'filename',
              path = 1,
              symbols = { modified = ' [✎] ', readonly = ' [] ' },
              color = { gui = 'italic,bold' },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              '%l/%L',
              icon = icons.misc.line,
              color = {
                gui = 'italic,bold',
              },
            },
          },
        },
        extensions = {
          'fugitive',
          'quickfix',
          {
            sections = { lualine_a = { function() return 'FZF' end } },
            filetypes = { 'fzf' },
          },
        },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'log',
          'fugitive',
          'gitcommit',
          'lazy',
          'markdown',
          'json',
          'notify',
          'mason',
          'txt',
          'help',
          'git',
          'undotree',
        },
      },
    },
    main = 'ibl',
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },

  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    tag = 'legacy',
    config = function()
      require('fidget').setup({
        window = {
          relative = 'editor',
        },
        text = {
          spinner = 'moon',
        },
      })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        command = 'silent! FidgetClose',
      })
    end,
  },

  {
    url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
    event = 'BufReadPost',
    config = true,
  },
}
