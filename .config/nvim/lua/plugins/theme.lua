return function()
  require('catppuccin').setup({
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    color_overrides = {
      mocha = {
        base = '#000000',
      },
    },
    highlight_overrides = {
      mocha = function(C)
        return {
          NeoTreeNormal = { bg = C.none },
          CmpBorder = { fg = C.surface2 },
          Pmenu = { bg = C.none },
          NormalFloat = { bg = C.none },
          TelescopeBorder = { link = 'FloatBorder' },
        }
      end,
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      leap = true,
      markdown = true,
      notify = true,
      nvimtree = false,
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
      neotree = {
        enabled = true,
        show_root = true, -- makes the root folder not transparent
        transparent_panel = false, -- make the panel transparent
      },
      harpoon = true,
      mason = true,
      neotest = true,
    },
  })

  vim.cmd.colorscheme('catppuccin')
end
