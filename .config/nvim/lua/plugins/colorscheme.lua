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
        on_colors = function(colors)
          colors.bg = '#161616'
          colors.bg_dark = '#080808'
          colors.bg_float = '#080808'
          colors.bg_sidebar = '#080808'
        end,
      }
    end,
  },
}
