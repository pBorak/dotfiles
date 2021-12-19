return function()
  vim.g.nvim_tree_icons = {
    default = '',
    git = {
      unstaged = '',
      staged = '',
      unmerged = '',
      renamed = '',
      untracked = '',
      deleted = '',
    },
  }

  gh.nnoremap('<leader>n', [[<cmd>NvimTreeToggle<CR>]])

  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_root_folder_modifier = ':t'
  vim.g.nvim_tree_highlight_opened_files = 1

  require('nvim-tree').setup {
    view = {
      width = '25%',
      auto_resize = true,
    },
    diagnostics = {
      enable = true,
    },
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    filters = {
      custom = { '.DS_Store', 'fugitive:', '.git', 'node_modules' },
    },
  }
end
