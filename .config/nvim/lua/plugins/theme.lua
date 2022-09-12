return function()
  local colors = require('catppuccin.palettes').get_palette()

  require('catppuccin').setup({
    compile = {
      enabled = true,
    },
    dim_inactive = {
      enabled = true,
    },
    integrations = {
      cmp = true,
      fidget = true,
      gitsigns = true,
      leap = true,
      markdown = true,
      neogit = false,
      notify = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
        },
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
    },
    highlight_overrides = {
      all = {},
    },
  })
  gh.augroup('CatppucinCompile', {
    {
      event = 'User',
      pattern = 'PackerCompileDone',
      desc = 'Compile Catppuccin and setup as a theme',
      command = function() vim.cmd('CatppuccinCompile') end,
    },
  })
  vim.cmd.colorscheme('catppuccin')
end
