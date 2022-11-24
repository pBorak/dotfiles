return function()
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
  -- <c-l> is selecting within a list of options.
  vim.keymap.set('i', '<c-l>', function()
    if ls.choice_active() then ls.change_choice(1) end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-j>', function()
    if ls.expand_or_jumpable() then ls.expand_or_jump() end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-k>', function()
    if ls.jumpable(-1) then ls.jump(-1) end
  end)

  require('luasnip.loaders.from_lua').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets' })
end
