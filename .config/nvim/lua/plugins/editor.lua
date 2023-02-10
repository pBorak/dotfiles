return {

  {
    'stevearc/oil.nvim',
    keys = {
      { '<leader>n', '<cmd>Oil<cr>' },
    },
    opts = {
      keymaps = {
        ['q'] = 'actions.close',
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    keys = { '<c-p>', '<leader>f' },
    opts = function()
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local themes = require('telescope.themes')

      ---@param prompt_bufnr number
      local open_in_diff_view = function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local value = action_state.get_selected_entry().value
        local cmd = 'DiffviewOpen ' .. value .. '~1..' .. value
        vim.cmd(cmd)
      end

      return {
        defaults = {
          prompt_prefix = require('config.icons').misc.telescope,
          selection_caret = require('config.icons').misc.chevron_right,
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<c-j>'] = actions.cycle_history_next,
              ['<c-k>'] = actions.cycle_history_prev,
              ['<c-b>'] = actions.preview_scrolling_up,
              ['<c-f>'] = actions.preview_scrolling_down,
              ['<c-l>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['<c-space>'] = actions.to_fuzzy_refine,
            },
          },
          file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf' },
        },
        extensions = {
          fzf = {
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
          },
        },
        pickers = {
          buffers = themes.get_dropdown({
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
          git_files = {
            file_ignore_patterns = { 'vendor/' },
          },
          live_grep = themes.get_ivy({
            file_ignore_patterns = { '.git/' },
            on_input_filter_cb = function(prompt)
              -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
              return { prompt = prompt:gsub('%s', '.*') }
            end,
          }),
          find_files = {
            hidden = true,
          },
          git_branches = themes.get_dropdown(),
          grep_string = themes.get_ivy(),
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
        },
      }
    end,
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('fzf')
      local builtins = require('telescope.builtin')

      local function project_files(args)
        if not pcall(builtins.git_files, args) then builtins.find_files(args) end
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
        builtins.grep_string({
          word_match = '-w',
        })
      end

      vim.keymap.set('n', '<c-p>', project_files)
      vim.keymap.set('n', '<leader>fd', dotfiles)
      vim.keymap.set('n', '<leader>fg', builtins.git_status)
      vim.keymap.set('n', '<leader>fc', builtins.git_commits)
      vim.keymap.set('n', '<leader>fb', builtins.git_branches)
      vim.keymap.set('n', '<leader>fo', builtins.buffers)
      vim.keymap.set('n', '<leader>fr', builtins.resume)
      vim.keymap.set('n', '<leader>fs', builtins.live_grep)
      vim.keymap.set('n', '<leader>ff', grep_string)
      vim.keymap.set('n', '<leader>f.', find_in_current_directory)
    end,
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },

  {
    'ggandor/leap.nvim',
    event = 'VeryLazy',
    dependencies = { { 'ggandor/flit.nvim', opts = { multiline = false } } },
    config = function()
      require('leap').add_default_mappings()
      local function leap_all_windows()
        require('leap').leap({
          target_windows = vim.tbl_filter(
            function(win) return vim.api.nvim_win_get_config(win).focusable end,
            vim.api.nvim_tabpage_list_wins(0)
          ),
        })
      end
      vim.keymap.set({ 'n', 'v' }, 's', leap_all_windows)
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '▌' },
        change = { text = '▌' },
        delete = { text = '▌' },
        topdelete = { text = '▌' },
        changedelete = { text = '▌' },
        untracked = { text = '▍' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r) vim.keymap.set(mode, l, r, { buffer = buffer }) end

        map('n', ']g', gs.next_hunk)
        map('n', '[g', gs.prev_hunk)
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>gw', gs.stage_buffer)
        map('n', '<leader>gr', gs.reset_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hl', function() gs.setqflist('all') end)
      end,
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'BufReadPost',
    config = true,
  },

  {
    'tpope/vim-projectionist',
    config = function() vim.keymap.set('n', '<leader>a', '<cmd>A<cr>') end,
  },

  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<c-h>', '<cmd>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd>TmuxNavigateRight<cr>' },
    },
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },

  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', '<localleader>m', require('harpoon.mark').add_file)
      vim.keymap.set('n', '<localleader><localleader>', require('harpoon.ui').toggle_quick_menu)

      vim.keymap.set(
        'n',
        '<localleader>a',
        '<cmd>lua require("harpoon.ui").nav_file(1)<cr>',
        { silent = true }
      )
      vim.keymap.set(
        'n',
        '<localleader>s',
        '<cmd>lua require("harpoon.ui").nav_file(2)<cr>',
        { silent = true }
      )
      vim.keymap.set(
        'n',
        '<localleader>d',
        ':lua require("harpoon.ui").nav_file(3)<cr>',
        { silent = true }
      )
      vim.keymap.set(
        'n',
        '<localleader>f',
        '<cmd>lua require("harpoon.ui").nav_file(4)<cr>',
        { silent = true }
      )
    end,
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = { preview = { auto_preview = false } },
  },

  {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
      { 'olimorris/neotest-rspec' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    keys = {
      { '<leader>ts', function() require('neotest').summary.toggle() end },
      {
        '<leader>to',
        function() require('neotest').output.open({ enter = true, short = false }) end,
      },
      { '<leader>tt', function() require('neotest').run.run() end },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end },
      { '<leader>tl', function() require('neotest').run.run_last() end },
      { '<leader>ta', function() require('neotest').run.attach() end },
    },
    opts = function()
      return {
        discovery = { enabled = true },
        diagnostic = {
          enabled = true,
        },
        adapters = {
          require('neotest-rspec')({
            rspec_cmd = './neotest_docker_script.sh',
          }),
        },
        icons = {
          expanded = '',
          child_prefix = '',
          child_indent = '',
          final_child_prefix = '',
          non_collapsible = '',
          collapsed = '',
          passed = '',
          running = '',
          failed = '',
          unknown = '',
          skipped = '',
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        floating = {
          border = 'single',
          max_height = 0.8,
          max_width = 0.9,
        },
      }
    end,
  },
}
