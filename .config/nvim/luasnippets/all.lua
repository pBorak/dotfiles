local ls = require('luasnip')

local snippet = ls.snippet
local d = ls.dynamic_node
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node

return {
  snippet({ trig = 'td', name = 'TODO' }, {
    d(1, function()
      local function with_cmt(cmt) return string.format(vim.bo.commentstring, ' ' .. cmt) end
      return snippet('', {
        c(1, {
          t(with_cmt('TODO: ')),
          t(with_cmt('NOTE: ')),
          t(with_cmt('FIXME: ')),
          t(with_cmt('HACK: ')),
          t(with_cmt('BUG: ')),
        }),
      })
    end),
    i(0),
  }),
}
