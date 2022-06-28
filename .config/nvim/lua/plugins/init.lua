local utils = require 'utils.plugins'

local conf = utils.conf
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath 'cache' .. '/packer/packer_compiled.lua'

-- Bootstrap Packer
utils.bootstrap_packer()

gh.safe_require 'impatient'

local packer = require 'packer'

packer.startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }
    ----------------------------------------------------------------------------
    -- Startup time improvements
    ----------------------------------------------------------------------------
    use 'lewis6991/impatient.nvim'
    use 'antoinemadec/FixCursorHold.nvim'
    ----------------------------------------------------------------------------
    -- Editor
    ----------------------------------------------------------------------------
    use 'tpope/vim-surround'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use 'vim-scripts/ReplaceWithRegister'
    use 'pbrisbin/vim-mkdir'
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
      keys = { '<c-p>', '<c-s>', '<leader>f' },
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
      },
    }
    use {
      'tpope/vim-projectionist',
      config = function()
        gh.nnoremap('<leader>a', '<cmd>A<cr>')
      end,
    }
    use {
      'ggandor/leap.nvim',
      config = function()
        require('leap').set_default_keymaps()
      end,
    }
    use {
      'rhysd/clever-f.vim',
      keys = { 'f', 'F', 't', 'T' },
      config = function()
        vim.g.clever_f_across_no_line = 1
        vim.g.clever_f_fix_key_direction = 1
      end,
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
    --
    use {
      'williamboman/nvim-lsp-installer',
      requires = { { 'neovim/nvim-lspconfig', config = conf 'lspconfig' } },
    }
    use 'folke/lua-dev.nvim'
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
        require('nvim-autopairs').setup {
          check_ts = true,
        }
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
      'akinsho/git-conflict.nvim',
      event = 'BufRead',
      config = function()
        require('git-conflict').setup()
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
      'rebelot/kanagawa.nvim',
      config = function()
        require('kanagawa').setup {
          globalStatus = true,
        }
      end,
    }
    use {
      'rcarriga/nvim-notify',
      config = conf 'notify',
    }
    use {
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup {
          text = {
            spinner = 'moon',
          },
        }
      end,
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
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('bqf').setup {
          preview = {
            auto_preview = false,
          },
        }
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
      'stevearc/dressing.nvim',
      config = conf 'dressing',
    }
    ----------------------------------------------------------------------------
    -- Syntax
    ----------------------------------------------------------------------------
    use {
      'nvim-treesitter/nvim-treesitter',
      config = conf 'treesitter',
    }
    use { 'RRethy/nvim-treesitter-endwise' }
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }
    use {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require('treesitter-context').setup()
      end,
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

gh.command('PackerCompiledEdit', function()
  vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
end)

gh.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  gh.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

gh.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/plugins/*.lua' },
    description = 'Packer setup and reload',
    command = function()
      gh.invalidate('plugins', true)
      packer.compile()
    end,
  },
})
gh.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
