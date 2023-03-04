local meh = { 'alt', 'ctrl', 'shift' }

local apps = {
  a = 'Alfred 5',
  j = 'Brave Browser',
  k = 'kitty',
  m = 'Spotify',
  p = '1Password 7',
  s = 'Slack',
  t = 'Things3',
  z = 'zoom.us',
}

local launchOrToggle = function(key, app_name, app_filename)
  hs.hotkey.bind(meh, key, function()
    local app = hs.application.find(app_name)
    -- Toggle - show
    local awin = nil
    if app then awin = app:mainWindow() end
    -- Toggle - hide
    if awin and app and app:isFrontmost() then
      app:hide()
    else
      -- Launch
      if app_filename then return hs.application.launchOrFocus(app_filename) end

      app = hs.application.find(app_name)

      hs.application.launchOrFocus(app_name)
      app.setFrontmost(app)
      app.activate(app)
    end
  end)
end

for key, app_name in pairs(apps) do
  if type(app_name) == 'table' then
    launchOrToggle(key, app_name[1], app_name[2])
  else
    launchOrToggle(key, app_name)
  end
end
