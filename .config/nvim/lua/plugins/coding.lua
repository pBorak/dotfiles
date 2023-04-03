return {

  {
    'L3MON4D3/LuaSnip',
    keys = {
      {
        '<tab>',
        function() return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>' end,
        expr = true,
        silent = true,
        mode = 'i',
      },
      {
        '<tab>',
        function() require('luasnip').jump(1) end,
        mode = 's',
      },
      {
        '<s-tab>',
        function() require('luasnip').jump(-1) end,
        mode = { 'i', 's' },
      },
      {
        '<c-l>',
        function()
          if require('luasnip').choice_active() then require('luasnip').change_choice(1) end
        end,
        mode = 'i',
      },
    },
    config = function()
      local ls = require('luasnip')
      local types = require('luasnip.util.types')
      local extras = require('luasnip.extras')
      local fmt = require('luasnip.extras.fmt').fmt

      ls.config.set_config({
        history = false,
        region_check_events = 'CursorMoved,CursorHold,InsertEnter',
        delete_check_events = 'InsertLeave',
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { '●', 'Operator' } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { '●', 'Type' } },
            },
          },
        },
        enable_autosnippets = true,
        snip_env = {
          fmt = fmt,
          t = ls.text_node,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          sn = ls.snippet_node,
          l = extras.lambda,
          snippet = ls.snippet,
        },
      })

      ls.filetype_extend('javascriptreact', { 'javascript' })
      require('luasnip.loaders.from_lua').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets' })
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'lukas-reineke/cmp-rg',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        },
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = function(_, item)
            local icons = require('config.icons').kinds
            if icons[item.kind] then item.kind = icons[item.kind] .. item.kind end
            return item
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        }, {
          {
            name = 'rg',
            keyword_length = 4,
            max_item_count = 5,
          },
        }),
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline', keyword_length = 2 },
        }),
      })
    end,
  },

  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {
      move_cursor = false,
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local autopairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      autopairs.setup({
        check_ts = true,
      })
      autopairs.add_rules({
        Rule('%(.*%)%s*%=$', '> {}', { 'javascriptreact', 'javascript' })
          :use_regex(true)
          :set_end_pair_length(1),
      })
    end,
  },

  { 'windwp/nvim-ts-autotag', event = 'VeryLazy' },

  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = true,
  },

  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    opts = {
      mappings = {
        goto_left = '',
        goto_right = '',
      },
    },
    config = function(_, opts)
      local ai = require('mini.ai')
      ai.setup(opts)
    end,
  },

  { 'vim-scripts/ReplaceWithRegister', event = 'VeryLazy' },

  { 'tpope/vim-eunuch', event = 'VeryLazy' },
}
