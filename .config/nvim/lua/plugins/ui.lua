return {

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
              'branch',
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
          lualine_x = {
            {
              'diagnostics',
              symbols = {
                error = icons.diagnostics.error,
                warn = icons.diagnostics.warn,
                info = icons.diagnostics.info,
                hint = icons.diagnostics.hint,
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
        extensions = {
          'fugitive',
          'quickfix',
        },
      }
    end,
  },

  {
    'echasnovski/mini.icons',
    lazy = true,
    opts = {},
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

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
}
