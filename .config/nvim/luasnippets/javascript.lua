local ls = require('luasnip')

local snippet = ls.snippet
local i = ls.insert_node
local l = require('luasnip.extras').lambda
local fmta = require('luasnip.extras.fmt').fmta

return {
  snippet(
    {
      trig = 'us',
      name = 'React useState',
      docstring = { 'const [value, setValue] = React.useState("defaultValue")' },
    },
    fmta('const [<value>, set<setter>] = React.useState(<initial_value>)', {
      value = i(1, 'value'),
      initial_value = i(2, 'initialValue'),
      setter = l(l._1:gsub('^%l', string.upper), 1),
    })
  ),
}
