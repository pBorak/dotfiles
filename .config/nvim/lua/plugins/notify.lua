return function()
  if vim.g.packer_compiled_loaded then
    return
  end

  local notify = require 'notify'
  ---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
  local renderer = require 'notify.render'
  notify.setup {
    stages = 'fade_in_slide_out',
    timeout = 3000,
    render = function(bufnr, notif, highlights)
      local style = notif.title[1] == '' and 'minimal' or 'default'
      renderer[style](bufnr, notif, highlights)
    end,
  }
  vim.notify = function(msg, level, opts)
    if msg:match 'Format request failed, no matching language servers.' then
      return
    end

    notify(msg, level, opts)
  end
end
