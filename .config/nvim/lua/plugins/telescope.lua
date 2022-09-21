local M = {}

gh.telescope = {}

local function rectangular_border(opts)
  return vim.tbl_deep_extend('force', opts or {}, {
    borderchars = {
      prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
      preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    },
  })
end

---@param opts table?
---@return table
function gh.telescope.dropdown(opts)
  return require('telescope.themes').get_dropdown(rectangular_border(opts))
end

function gh.telescope.ivy(opts)
  return require('telescope.themes').get_ivy(vim.tbl_deep_extend('keep', opts or {}, {
    borderchars = {
      preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    },
  }))
end

function M.config()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  ---@param prompt_bufnr number
  local open_in_diff_view = function(prompt_bufnr)
    actions.close(prompt_bufnr)
    local value = action_state.get_selected_entry().value
    local cmd = 'DiffviewOpen ' .. value .. '~1..' .. value
    vim.cmd(cmd)
  end

  local function stopinsert(callback)
    return function(prompt_bufnr)
      vim.cmd.stopinsert()
      vim.schedule(function() callback(prompt_bufnr) end)
    end
  end

  telescope.setup({
    defaults = {
      set_env = { ['TERM'] = vim.env.TERM },
      borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt_prefix = gh.style.icons.misc.telescope .. ' ',
      selection_caret = gh.style.icons.misc.chevron_right .. ' ',
      mappings = {
        i = {
          ['<c-c>'] = function() vim.cmd.stopinsert() end,
          ['<esc>'] = actions.close,
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
          ['<c-b>'] = actions.preview_scrolling_up,
          ['<c-f>'] = actions.preview_scrolling_down,
          ['<c-l>'] = actions.smart_send_to_qflist + actions.open_qflist,
          ['<CR>'] = stopinsert(actions.select_default),
        },
      },
      file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf' },
      layout_strategy = 'flex',
      layout_config = {
        horizontal = {
          preview_width = 0.45,
        },
      },
    },
    extensions = {
      fzf = {
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
      },
    },
    pickers = {
      buffers = gh.telescope.dropdown({
        sort_mru = true,
        sort_lastused = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        previewer = false,
        mappings = {
          i = { ['<c-x>'] = 'delete_buffer' },
          n = { ['<c-x>'] = 'delete_buffer' },
        },
      }),
      oldfiles = gh.telescope.dropdown(),
      git_files = {
        file_ignore_patterns = { 'vendor/' },
      },
      live_grep = {
        file_ignore_patterns = { '.git/' },
        on_input_filter_cb = function(prompt)
          -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
          return { prompt = prompt:gsub('%s', '.*') }
        end,
      },
      current_buffer_fuzzy_find = gh.telescope.dropdown({
        previewer = false,
        shorten_path = false,
      }),
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        hidden = true,
      },
      git_branches = gh.telescope.dropdown(),
      git_bcommits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
        mappings = {
          i = {
            ['<cr>'] = open_in_diff_view,
          },
        },
      },
      git_commits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
        mappings = {
          i = {
            ['<cr>'] = open_in_diff_view,
          },
        },
      },
      reloader = gh.telescope.dropdown(),
    },
  })

  --- NOTE: this must be required after setting up telescope
  --- otherwise the result will be cached without the updates
  --- from the setup call
  local builtins = require('telescope.builtin')

  local function project_files(opts)
    if not pcall(builtins.git_files, opts) then builtins.find_files(opts) end
  end

  local function dotfiles()
    builtins.find_files({
      prompt_title = '~ dotfiles ~',
      cwd = vim.env.DOTFILES,
    })
  end

  local function find_in_current_directory()
    builtins.find_files({
      prompt_title = '~ current directory files ~',
      cwd = '%:h',
    })
  end

  local function grep_string()
    builtins.grep_string(gh.telescope.ivy({
      word_match = '-w',
    }))
  end

  local function live_grep_args()
    telescope.extensions.live_grep_args.live_grep_args(gh.telescope.ivy())
  end

  gh.nnoremap('<c-p>', project_files)
  gh.nnoremap('<leader>fd', dotfiles)
  gh.nnoremap('<leader>fg', builtins.git_status)
  gh.nnoremap('<leader>fc', builtins.git_commits)
  gh.nnoremap('<leader>fb', builtins.git_branches)
  gh.nnoremap('<leader>fo', builtins.buffers)
  gh.nnoremap('<leader>fr', builtins.resume)
  gh.nnoremap('<leader>fs', live_grep_args)
  gh.nnoremap('<leader>ff', grep_string)
  gh.nnoremap('<leader>f.', find_in_current_directory)
end

return M
