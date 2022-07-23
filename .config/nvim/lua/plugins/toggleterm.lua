return function()
  require('toggleterm').setup({
    open_mapping = [[<c-\>]],
    shade_filetypes = { 'none' },
    direction = 'horizontal',
    start_in_insert = true,
    float_opts = { border = 'curved', winblend = 3 },
    size = function(term)
      if term.direction == 'horizontal' then
        return 30
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
  })

  local Terminal = require('toggleterm.terminal').Terminal

  local htop = Terminal:new({
    cmd = 'htop',
    hidden = 'true',
    direction = 'float',
  })

  gh.command('Htop', function() htop:toggle() end)
end
