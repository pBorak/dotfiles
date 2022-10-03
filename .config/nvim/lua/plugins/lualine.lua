return function()
  local icons = gh.style.icons

  local function window_wide_enough() return vim.fn.winwidth(0) > 80 end

  local function search_result()
    if vim.v.hlsearch == 0 then return '' end
    local last_search = vim.fn.getreg('/')
    if not last_search or last_search == '' then return '' end
    local searchcount = vim.fn.searchcount({ maxcount = 9999 })
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
          search_result,
          cond = window_wide_enough,
        },
      },
      lualine_c = {
        function() return '%=' end,
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
          cond = window_wide_enough,
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = icons.lsp.error .. ' ',
            warn = icons.lsp.warn .. ' ',
            info = icons.lsp.info .. ' ',
            hint = icons.lsp.hint .. ' ',
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
        },
      },
      lualine_y = {
        {
          'b:gitsigns_head',
          cond = window_wide_enough,
          icon = icons.misc.git_branch,
          color = {
            gui = 'bold',
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
