---@diagnostic disable: undefined-global

return {
  snippet(
    {
      trig = 'us',
      name = 'React useState',
      docstring = { 'const [value, setValue] = React.useState("defaultValue")' },
    },
    fmt('const [{}, set{setter}] = React.useState({})', {
      i(1, 'value'),
      i(2, 'initialValue'),
      setter = l(l._1:gsub('^%l', string.upper), 1),
    })
  ),
}