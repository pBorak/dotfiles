local meh = { 'alt', 'ctrl', 'shift' }
local notify = function()
  hs.notify.new({ title = 'Hammerspoon', informativeText = 'Config reloaded' }):send()
end

hs.hotkey.bind(meh, '0', function()
  notify()
  hs.reload()
end)

require('launcher')
