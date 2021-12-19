return function()
  vim.g.tmux_navigator_no_mappings = 1
  gh.nnoremap('<c-h>', '<cmd>TmuxNavigateLeft<cr>')
  gh.nnoremap('<c-j>', '<cmd>TmuxNavigateDown<cr>')
  gh.nnoremap('<c-k>', '<cmd>TmuxNavigateUp<cr>')
  gh.nnoremap('<c-l>', '<cmd>TmuxNavigateRight<cr>')
  -- Disable tmux navigator when zooming the Vim pane
  vim.g.tmux_navigator_disable_when_zoomed = 1
  vim.g.tmux_navigator_preserve_zoom = 1
  vim.g.tmux_navigator_save_on_switch = 2
end
