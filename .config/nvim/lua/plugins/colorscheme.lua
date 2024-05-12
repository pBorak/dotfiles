return {

  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    priority = 1000,
    opts = {
      color_overrides = {
        mocha = {
          base = '#080808',
          mantle = '#080808',
          crust = '#080808',
        },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        diffview = true,
        harpoon = true,
        mason = true,
        neotest = true,
        notify = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        mini = {
          enabled = true,
        },
      },
    },
  },
}
