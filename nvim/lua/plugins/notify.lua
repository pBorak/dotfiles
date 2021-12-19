return function()
  local notify = require 'notify'
  notify.setup {
    stages = 'fade_in_slide_out', -- fade
    timeout = 3000,
    background_colour = '#24283b',
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  }
  ---Send a notification
  --@param msg of the notification to show to the user
  --@param level Optional log level
  --@param opts Dictionary with optional options (timeout, etc)
  vim.notify = function(msg, level, opts)
    local l = vim.log.levels
    opts = opts or {}
    level = level or l.INFO
    local levels = {
      [l.DEBUG] = 'Debug',
      [l.INFO] = 'Information',
      [l.WARN] = 'Warning',
      [l.ERROR] = 'Error',
    }
    opts.title = opts.title or type(level) == 'string' and level or levels[level]
    notify(msg, level, opts)
  end
end
