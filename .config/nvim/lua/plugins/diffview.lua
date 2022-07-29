return function()
  gh.nnoremap('<leader>gd', '<Cmd>DiffviewOpen<CR>')
  gh.nnoremap('<leader>gh', '<Cmd>DiffviewFileHistory<CR>')
  gh.vnoremap('<leader>gh', [[:'<'>DiffviewFileHistory<CR>]])
  require('diffview').setup({
    default_args = {
      DiffviewFileHistory = { '%' },
    },
    enhanced_diff_hl = true,
    keymaps = {
      view = {
        q = '<Cmd>DiffviewClose<CR>',
      },
      file_panel = {
        q = '<Cmd>DiffviewClose<CR>',
      },
      file_history_panel = {
        q = '<Cmd>DiffviewClose<CR>',
      },
    },
  })
end
