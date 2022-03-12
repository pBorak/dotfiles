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
      if notif.title[1] == '' then
        return renderer.minimal(bufnr, notif, highlights)
      end
      return renderer.default(bufnr, notif, highlights)
    end,
  }
  vim.notify = notify
  gh.nnoremap('<leader>pd', notify.dismiss)
end
