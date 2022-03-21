---@diagnostic disable: undefined-global

return {
  snippet({ trig = 'td', name = 'TODO' }, {
    c(1, {
      t 'TODO: ',
      t 'FIXME: ',
      t 'HACK: ',
      t 'BUG: ',
    }),
    i(0),
  }),
}
