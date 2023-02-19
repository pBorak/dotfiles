return {

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = function()
      vim.api.nvim_set_hl(0, '@label.ruby', { bold = true, fg = '#4fd6be' })

      return {
        style = 'moon',
        sidebars = {
          'qf',
          'packer',
          'help',
          'startuptime',
          'fugitive',
          'undotree',
        },
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          local prompt = '#2d3149'
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
      }
    end,
  },
}
