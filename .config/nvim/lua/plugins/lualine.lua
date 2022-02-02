return function()
  local colors = {
    bg_statusline = '#2A2A37',
    blue = '#7E9CD8',
    fg_sidebar = '#C8C093',
    st_grey = '#727169',
  }

  local function window_wide_enough()
    return vim.fn.winwidth(0) > 80
  end

  local function search_result()
    if vim.v.hlsearch == 0 then
      return ''
    end
    local last_search = vim.fn.getreg '/'
    if not last_search or last_search == '' then
      return ''
    end
    local searchcount = vim.fn.searchcount { maxcount = 9999 }
    return searchcount.current .. '/' .. searchcount.total
  end

  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end

  local config = {
    options = {
      theme = 'kanagawa',
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      icons_enabled = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        {
          search_result,
          cond = window_wide_enough,
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
        {
          function()
            local gps = require 'nvim-gps'
            return gps.get_location()
          end,
          cond = function()
            local gps = require 'nvim-gps'
            return pcall(require, 'nvim-treesitter.parsers')
              and gps.is_available()
              and window_wide_enough()
          end,
          color = {
            fg = colors.st_grey,
          },
        },
      },
      lualine_x = {
        {
          'diagnostics',
          cond = window_wide_enough,
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = gh.style.icons.error .. '  ',
            warn = gh.style.icons.warn .. ' ',
            info = gh.style.icons.info .. ' ',
            hint = gh.style.icons.hint .. ' ',
          },
        },
      },
      lualine_y = {
        {
          'b:gitsigns_head',
          cond = window_wide_enough,
          icon = '',
          color = {
            bg = colors.bg_statusline,
            fg = colors.blue,
            gui = 'bold',
          },
        },
        {
          'diff',
          cond = window_wide_enough,
          source = diff_source,
          color = { bg = colors.bg_statusline },
          symbols = {
            added = ' ',
            modified = ' ',
            removed = ' ',
          },
        },
      },
      lualine_z = {
        {
          '%l/%L',
          cond = window_wide_enough,
          icon = 'ℓ',
          color = {
            bg = colors.bg_statusline,
            fg = colors.fg_sidebar,
            gui = 'italic,bold',
          },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filetype',
          icon_only = true,
          padding = { left = 1, right = 0 },
        },
        'filename',
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { 'nvim-tree', 'fugitive', 'toggleterm', 'quickfix' },
  }

  require('lualine').setup(config)
end
