return function()
  local cmp = require 'cmp'
  local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

  local function tab(fallback)
    local ok, luasnip = gh.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_next_item()
    elseif ok and luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    local ok, luasnip = gh.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_prev_item()
    elseif ok and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end

  cmp.setup {
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = {
      ghost_text = true,
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    formatting = {
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = gh.style.lsp.kinds[vim_item.kind]
        local name = entry.source.name
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          path = '[Path]',
          luasnip = '[Luasnip]',
          buffer = '[Buffer]',
          spell = '[Spell]',
          cmdline = '[Command]',
        })[name]
        return vim_item
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'spell' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline('?', {
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline', keyword_length = 2 },
    }),
  })
end
