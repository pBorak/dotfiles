local utils = require 'utils.plugins'

local conf = utils.conf
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath 'cache' .. '/packer/packer_compiled.lua'

-- Bootstrap Packer
utils.bootstrap_packer()

gh.safe_require 'impatient'

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }
    ----------------------------------------------------------------------------
    -- Startup time improvements
    ----------------------------------------------------------------------------
    use 'lewis6991/impatient.nvim'
    use 'nathom/filetype.nvim'
    ----------------------------------------------------------------------------
    -- Editor
    ----------------------------------------------------------------------------
    use 'tpope/vim-surround'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use 'vim-scripts/ReplaceWithRegister'
    use 'pbrisbin/vim-mkdir'
    use {
      'romainl/vim-qf',
      ft = 'qf',
    }
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    }
    use {
      'AndrewRadev/splitjoin.vim',
      keys = { 'gS', 'gJ' },
      config = function()
        vim.g.splitjoin_ruby_curly_braces = 0
        vim.g.splitjoin_ruby_hanging_args = 0
      end,
    }
    use {
      'akinsho/toggleterm.nvim',
      keys = [[<c-\>]],
      event = 'BufRead',
      config = conf 'toggleterm',
    }
    use {
      'vim-test/vim-test',
      keys = { '<leader>tf', '<leader>ta', '<leader>tt' },
      config = conf 'vim-test',
    }
    ----------------------------------------------------------------------------
    -- Navigation
    ----------------------------------------------------------------------------
    use {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<c-p>', '<leader>f' },
      config = conf 'telescope',
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'fzf'
          end,
        },
        {
          'camgraff/telescope-tmux.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'tmux'
          end,
        },
      },
    }
    use {
      '~/code/vim-projectionist',
      config = function()
        gh.nnoremap('<leader>a', '<cmd>A<cr>')
      end,
    }
    use {
      'ggandor/lightspeed.nvim',
      keys = { 's', 'S', 'f', 'F', 't', 'T' },
    }
    use {
      'christoomey/vim-tmux-navigator',
      config = conf 'vim-tmux-navigator',
    }
    use {
      'ThePrimeagen/harpoon',
      config = conf 'harpoon',
    }
    ----------------------------------------------------------------------------
    -- LSP & Completion
    ----------------------------------------------------------------------------
    use {
      'neovim/nvim-lspconfig',
      config = conf 'lspconfig',
    }
    use {
      'folke/lua-dev.nvim',
      commit = 'e958850',
    }
    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = conf 'null-ls',
    }
    use {
      'hrsh7th/nvim-cmp',
      event = { 'InsertEnter', 'CmdlineEnter' },
      requires = {
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      },
      config = conf 'cmp',
    }
    use {
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      config = conf 'luasnip',
    }
    use {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        local pairs = require 'nvim-autopairs'
        pairs.setup {}
        pairs.add_rules(require 'nvim-autopairs.rules.endwise-ruby')
      end,
    }
    ----------------------------------------------------------------------------
    -- Git
    ----------------------------------------------------------------------------
    use {
      'tpope/vim-fugitive',
      keys = { '<leader>gs' },
      event = 'BufRead',
      config = function()
        gh.nnoremap('<leader>gs', '<cmd>G<CR>')
        gh.nnoremap('<leader>gb', '<cmd>G blame<CR>')
      end,
    }
    use {
      'christoomey/vim-conflicted',
      cmd = 'Conflicted',
      config = function()
        gh.nnoremap('<leader>gnc', '<cmd>GitNextConflict<CR>')
      end,
    }
    use {
      'lewis6991/gitsigns.nvim',
      event = 'BufRead',
      requires = 'nvim-lua/plenary.nvim',
      config = conf 'gitsigns',
    }
    use {
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = { '<leader>xl', '<leader>xo' },
      config = conf 'gitlinker',
    }
    use {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      module = 'diffview',
      keys = { '<leader>gd', '<leader>gh' },
      config = conf 'diffview',
    }
    ----------------------------------------------------------------------------
    -- UI
    ----------------------------------------------------------------------------
    use {
      'folke/tokyonight.nvim',
      config = function()
        vim.g.tokyonight_sidebars = { 'qf', 'packer', 'fugitive' }
        vim.g.tokyonight_lualine_bold = true
      end,
    }
    use {
      'rcarriga/nvim-notify',
      config = conf 'notify',
    }
    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      keys = '<leader>u',
      config = function()
        vim.g.undotree_TreeNodeShape = '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
        gh.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>')
      end,
    }
    use {
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufRead',
      config = function()
        require('pqf').setup()
      end,
    }
    use {
      'norcalli/nvim-colorizer.lua',
      ft = { 'html', 'css', 'sass' },
      config = function()
        require('colorizer').setup({ '*' }, {
          RGB = false,
        })
      end,
    }
    use {
      'lukas-reineke/indent-blankline.nvim',
      event = 'BufRead',
      config = conf 'indent-blankline',
    }
    use {
      'kyazdani42/nvim-tree.lua',
      keys = '<leader>n',
      config = conf 'nvim-tree',
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use {
      'nvim-lualine/lualine.nvim',
      event = 'BufRead',
      config = conf 'lualine',
      requires = 'nvim-web-devicons',
    }
    use {
      'SmiteshP/nvim-gps',
      requires = 'nvim-treesitter/nvim-treesitter',
      module = 'nvim-gps',
      config = conf 'nvim-gps',
    }
    use {
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup {
          select = {
            telescope = {
              theme = 'cursor',
            },
          },
        }
      end,
    }
    ----------------------------------------------------------------------------
    -- Syntax
    ----------------------------------------------------------------------------
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      event = 'BufRead',
      config = conf 'treesitter',
      requires = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
        {
          'nvim-treesitter/playground',
          cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
        },
      },
    }
    ----------------------------------------------------------------------------
    -- Utils
    ----------------------------------------------------------------------------
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = function()
        vim.g.startuptime_tries = 15
      end,
    }
  end,
  config = {
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = 'rounded',
      open_cmd = 'silent topleft 65vnew',
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
}

gh.command {
  'PackerCompiledEdit',
  function()
    vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
  end,
}

gh.command {
  'PackerCompiledDelete',
  function()
    vim.fn.delete(PACKER_COMPILED_PATH)
    packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
  end,
}

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  gh.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

gh.augroup('PackerSetupInit', {
  {
    events = { 'BufWritePost' },
    targets = { '*/plugins/*.lua' },
    command = function()
      gh.invalidate('plugins', true)
      require('packer').compile()
    end,
  },
})
gh.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
