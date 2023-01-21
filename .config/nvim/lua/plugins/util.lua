return {

  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function() vim.g.startuptime_tries = 15 end,
  },

  { 'nvim-lua/plenary.nvim', lazy = true },

  { 'tpope/vim-repeat', event = 'VeryLazy' },
}
