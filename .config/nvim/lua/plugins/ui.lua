return {

  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({
        render = function(...)
          local notif = select(2, ...)
          local style = notif.title[1] == '' and 'minimal' or 'default'
          require('notify.render')[style](...)
        end,
      })
      vim.notify = function(msg, level, opts)
        if msg:match('Format request failed, no matching language servers.') then return end

        notify(msg, level, opts)
      end

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
          lualine_b = {},
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
          lualine_x = {
            {
              'b:gitsigns_head',
              icon = icons.misc.git_branch,
              color = {
                gui = 'bold',
              },
            },
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = {
                error = icons.diagnostics.error,
                warn = icons.diagnostics.warn,
                info = icons.diagnostics.info,
                hint = icons.diagnostics.hint,
              },
            },
            {
              'diff',
              symbols = {
                added = icons.git.add,
                modified = icons.git.mod,
                removed = icons.git.remove,
              },
            },
          },
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
        extensions = { 'neo-tree', 'fugitive', 'toggleterm', 'quickfix' },
      }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPost',
    opts = {
      char = '│',
      context_char = '┃',
      show_current_context = true,
      filetype_exclude = {
        'log',
        'fugitive',
        'gitcommit',
        'packer',
        'markdown',
        'json',
        'txt',
        'help',
        'git',
        'TelescopePrompt',
        'undotree',
        'neo-tree-popup',
        '', -- for all buffers without a file type
      },
      buftype_exclude = { 'terminal', 'nofile' },
    },
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { 'MunifTanjim/nui.nvim', lazy = true },

  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
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
