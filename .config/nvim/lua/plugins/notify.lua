return function()
  local notify = require('notify')
  notify.setup({
    stages = 'fade_in_slide_out',
    timeout = 3000,
    top_down = false,
    background_colour = '#222436',
    render = function(...)
      local notif = select(2, ...)
      local style = notif.title[1] == '' and 'minimal' or 'default'
      require('notify.render')[style](...)
    end,
    on_open = function(win) vim.api.nvim_win_set_config(win, { focusable = false }) end,
  })

  gh.nnoremap('<leader>N', notify.dismiss)
end
