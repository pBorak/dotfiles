return {

  {
    'L3MON4D3/LuaSnip',
    keys = {
      {
        '<c-k>',
        function() return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1) end,
        mode = { 'i', 's' },
      },
      {
        '<c-j>',
        function() return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1) end,
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

      vim.snippet.expand = ls.lsp_expand

      vim.snippet.active = function(filter)
        filter = filter or {}
        filter.direction = filter.direction or 1

        if filter.direction == 1 then
          return ls.expand_or_jumpable()
        else
          return ls.jumpable(filter.direction)
        end
      end

      vim.snippet.jump = function(direction)
        if direction == 1 then
          if ls.expandable() then
            return ls.expand_or_jump()
          else
            return ls.jumpable(1) and ls.jump(1)
          end
        else
          return ls.jumpable(-1) and ls.jump(-1)
        end
      end

      vim.snippet.stop = ls.unlink_current

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
      })

      ls.filetype_extend('javascriptreact', { 'javascript' })
      require('luasnip.loaders.from_lua').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets' })
    end,
  },

  {
    'iguanacucumber/magazine.nvim',
    name = 'nvim-cmp',
    event = { 'InsertEnter' },
    dependencies = {
      { 'iguanacucumber/mag-nvim-lsp', name = 'cmp-nvim-lsp', opts = {} },
      { 'https://codeberg.org/FelipeLema/cmp-async-path', name = 'async_path' },
      { 'iguanacucumber/mag-buffer', name = 'cmp-buffer' },
      'saadparwaiz1/cmp_luasnip',
      'lukas-reineke/cmp-rg',
      {
        'zbirenbaum/copilot-cmp',
        dependencies = 'copilot.lua',
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup(opts)
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
          expand = function(args) vim.snippet.expand(args.body) end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<c-y>'] = cmp.mapping.confirm({
            select = true,
          }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'copilot' },
          { name = 'async_path' },
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
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },

  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    config = function()
      require('mini.surround').setup({
        mappings = {
          add = 'ys',
          delete = 'ds',
          find = '',
          find_left = '',
          highlight = '',
          replace = 'cs',
          update_n_lines = '',
          suffix_last = '',
          suffix_next = '',
        },
        search_method = 'cover_or_next',
      })

      vim.keymap.del('x', 'ys')
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

      -- Make special mapping for "add surrounding for line"
      vim.keymap.set('n', 'yss', 'ys_', { remap = true })
    end,
  },

  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')

      return {
        mappings = {
          goto_left = '',
          goto_right = '',
        },
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
    end,
  },

  {
    'echasnovski/mini.operators',
    event = 'VeryLazy',
    config = true,
  },
}
