vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local ok, reload = pcall(require, 'plenary.reload')
RELOAD = ok and reload.reload_module or function(...) return ... end
function R(name)
  RELOAD(name)
  return require(name)
end

-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup('vimrc', {})

R('globals')
R('settings')
R('plugins')

vim.cmd.colorscheme('kanagawa')
