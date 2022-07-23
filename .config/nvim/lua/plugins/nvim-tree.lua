return function()
  gh.nnoremap('<leader>n', [[<cmd>NvimTreeToggle<CR>]])

  require('nvim-tree').setup({
    view = {
      width = '25%',
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
    git = {
      ignore = false,
    },
    filters = {
      custom = { '.DS_Store', 'fugitive:', 'vendor', '.git', 'node_modules' },
    },
    renderer = {
      indent_markers = {
        enable = true,
      },
      group_empty = true,
      highlight_git = true,
      root_folder_modifier = ':t',
      highlight_opened_files = 'icon',
      icons = {
        glyphs = {
          default = '',
          git = {
            unstaged = '',
            staged = '',
            unmerged = '',
            renamed = '',
            untracked = '',
            deleted = '',
          },
        },
      },
    },
  })
end
