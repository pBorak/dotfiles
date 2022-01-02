vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...)
  return ...
end
function R(name)
  RELOAD(name)
  return require(name)
end

R 'globals'
R 'settings'
R 'plugins'

if gh.plugin_installed 'tokyonight.nvim' then
  require('tokyonight').colorscheme()
end
