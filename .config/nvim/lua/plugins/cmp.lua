return function()
  local cmp = require('cmp')
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')

  local has_words_before = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return col ~= 0 and vim.api.nvim_get_current_line():sub(col, col):match('%s') == nil
  end

  local function tab(fallback)
    local ok, luasnip = gh.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_next_item()
    elseif ok and luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
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
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end

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
      ['<Tab>'] = tab,
      ['<S-Tab>'] = shift_tab,
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
    },
    formatting = {
      deprecated = true,
      fields = { 'abbr', 'kind', 'menu' },
      format = function(entry, vim_item)
        local maxwidth = 35
        if #vim_item.abbr > maxwidth then
          vim_item.abbr = vim_item.abbr:sub(1, maxwidth) .. '…'
        end
        vim_item.kind = string.format('%s %s', vim_item.kind, gh.style.lsp.kinds[vim_item.kind])
        local name = entry.source.name
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          path = '[Path]',
          luasnip = '[SN]',
          buffer = '[B]',
          spell = '[SP]',
          cmdline = '[CMD]',
        })[name]
        return vim_item
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
      { name = 'spell' },
    }),
  })

  local cmdline_mappings = {
    select_next_item = {
      c = function(fallback)
        if cmp.visible() then
          return cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })(fallback)
        else
          return cmp.mapping.complete({ reason = cmp.ContextReason.Auto })(fallback)
        end
      end,
    },
    select_prev_item = {
      c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    },
  }

  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

  cmp.setup.cmdline('/', {
    mapping = {
      ['<Tab>'] = cmdline_mappings.select_next_item,
      ['<S-Tab>'] = cmdline_mappings.select_prev_item,
    },
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline('?', {
    mapping = {
      ['<Tab>'] = cmdline_mappings.select_next_item,
      ['<S-Tab>'] = cmdline_mappings.select_prev_item,
    },
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    mapping = {
      ['<Tab>'] = cmdline_mappings.select_next_item,
      ['<S-Tab>'] = cmdline_mappings.select_prev_item,
    },
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'cmdline', keyword_length = 2 },
    }),
  })
end
