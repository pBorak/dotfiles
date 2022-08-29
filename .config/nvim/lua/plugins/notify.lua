return function()
  local notify = require('notify')
  notify.setup({
    stages = 'fade_in_slide_out',
    timeout = 3000,
    background_colour = '#16161D',
    render = function(...)
      local notif = select(2, ...)
      local style = notif.title[1] == '' and 'minimal' or 'default'
      require('notify.render')[style](...)
    end,
  })
  vim.notify = function(msg, level, opts)
    if msg:match('Format request failed, no matching language servers.') then return end

    notify(msg, level, opts)
  end

  gh.nnoremap('<leader>N', notify.dismiss)
end
