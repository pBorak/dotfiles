return function()
  local icons = gh.style.icons
  vim.g.neo_tree_remove_legacy_commands = 1

  gh.nnoremap('<leader>n', '<Cmd>Neotree toggle reveal<CR>')

  require('neo-tree').setup({
    close_if_last_window = true,
    sources = {
      'filesystem',
    },
    filesystem = {
      use_libuv_file_watcher = true,
      group_empty_dirs = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {
          '.DS_Store',
        },
      },
    },
    default_component_configs = {
      icon = {
        folder_empty = '',
      },
      diagnostics = {
        highlights = {
          hint = 'DiagnosticHint',
          info = 'DiagnosticInfo',
          warn = 'DiagnosticWarn',
          error = 'DiagnosticError',
        },
      },
      modified = {
        symbol = icons.misc.circle .. ' ',
      },
      git_status = {
        symbols = {
          added = icons.git.add,
          deleted = icons.git.remove,
          modified = icons.git.mod,
          renamed = icons.git.rename,
          untracked = '',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
    window = {
      mappings = {
        ['<CR>'] = 'open_with_window_picker',
        ['w'] = 'noop',
        ['<space>'] = 'noop',
        ['<tab>'] = 'toggle_node',
      },
    },
  })
end
