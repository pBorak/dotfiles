return function()
  local icons = gh.style.icons

  local function window_wide_enough() return vim.fn.winwidth(0) > 80 end

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
          cond = window_wide_enough,
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
          require('noice').api.statusline.message.get_hl,
          cond = require('noice').api.statusline.message.has,
        },
        {
          require('noice').api.statusline.mode.get,
          cond = require('noice').api.statusline.mode.has,
          color = { fg = '#ff9e64' },
        },
      },
      lualine_y = {
        {
          'diagnostics',
          cond = window_wide_enough,
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = icons.lsp.error .. ' ',
            warn = icons.lsp.warn .. ' ',
            info = icons.lsp.info .. ' ',
            hint = icons.lsp.hint .. ' ',
          },
          color = {
            bg = '#1e2030',
          },
        },
        {
          'diff',
          cond = window_wide_enough,
          source = diff_source,
          symbols = {
            added = icons.git.add .. ' ',
            modified = icons.git.mod .. ' ',
            removed = icons.git.remove .. ' ',
          },
          color = {
            bg = '#1e2030',
          },
        },
      },
      lualine_z = {
        {
          '%l/%L',
          cond = window_wide_enough,
          icon = icons.misc.line,
          color = {
            gui = 'italic,bold',
          },
        },
      },
    },
    extensions = { 'neo-tree', 'fugitive', 'toggleterm', 'quickfix' },
  }

  require('lualine').setup(config)
end
