return function()
  local colors = {
    bg_statusline = '#1f2335',
    blue = '#7aa2f7',
    fg_sidebar = '#a9b1d6',
    magenta = '#bb9af7',
    st_grey = '#565f89',
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

  local function lsp_progress(_, is_active)
    if not is_active then
      return
    end
    local messages = vim.lsp.util.get_progress_messages()
    if #messages == 0 then
      return ''
    end
    local status = {}
    for _, msg in pairs(messages) do
      local title = ''
      if msg.title then
        title = msg.title
      end

      table.insert(status, (msg.percentage or 0) .. '%% ' .. title)
    end
    local spinners = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    return table.concat(status, ' | ') .. ' ' .. spinners[frame + 1]
  end

  vim.cmd 'au User LspProgressUpdate let &ro = &ro'

  local config = {
    options = {
      theme = 'tokyonight',
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
          lsp_progress,
          cond = window_wide_enough,
          color = { fg = colors.magenta },
        },
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
