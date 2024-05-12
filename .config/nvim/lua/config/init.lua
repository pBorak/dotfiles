local function load(name)
  local Util = require('lazy.core.util')

  for _, mod in ipairs({ 'config.' .. name }) do
    Util.try(function() require(mod) end, {
      msg = 'Failed loading ' .. mod,
      on_error = function(msg)
        local modpath = require('lazy.core.cache').find(mod)
        if modpath then Util.error(msg) end
      end,
    })
  end
end

-- load options here, before lazy init while sourcing plugin modules
-- this is needed to make sure options will be correctly applied
-- after installing missing plugins

require('config.options')
require('config.lazy')

if vim.fn.argc() == 0 then
  -- autocmds and keymaps can wait to load
  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('BlazinglyFast', { clear = true }),
    pattern = 'VeryLazy',
    callback = function()
      load('autocmds')
      load('keymaps')
    end,
  })
else
  -- load them now so they affect the opened buffers
  load('autocmds')
  load('keymaps')
end

vim.cmd.colorscheme('catppuccin')
