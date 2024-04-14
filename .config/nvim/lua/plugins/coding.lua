return {

  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
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
    event = { 'InsertEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'lukas-reineke/cmp-rg',
      {
        'zbirenbaum/copilot-cmp',
        dependencies = 'copilot.lua',
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup(opts)
          require('util.init').on_lsp_attach(function(client)
            if client.name == 'copilot' then copilot_cmp._on_insert_enter({}) end
          end)
        end,
      },
    },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require('cmp')
      return {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = {
            follow_cursor = true,
          },
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
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
            select = true,
          }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'copilot' },
          { name = 'path' },
          { name = 'buffer' },
        }, {
          {
            name = 'rg',
            keyword_length = 4,
          },
        }),
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = function(_, item)
            local icons = require('config.icons').kinds
            if icons[item.kind] then item.kind = icons[item.kind] .. item.kind end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
      }
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {
      move_cursor = false,
    },
  },

  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = {
      mappings = {
        goto_left = '',
        goto_right = '',
      },
    },
  },

  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      mappings = {
        ['`'] = {
          action = 'closeopen',
          pair = '``',
          neigh_pattern = '[^\\`].',
          register = { cr = false },
        },
      },
    },
  },

  { 'windwp/nvim-ts-autotag', event = 'VeryLazy' },

  {
    'echasnovski/mini.comment',
    event = 'VeryLazy',
    opts = {},
  },

  { 'vim-scripts/ReplaceWithRegister', event = 'VeryLazy' },

  { 'tpope/vim-eunuch', event = 'VeryLazy' },
}
