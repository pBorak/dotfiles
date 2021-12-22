local fn = vim.fn
local opt = vim.opt
--------------------------------------------------------------------------------
---- Don't load the plugins below
--------------------------------------------------------------------------------
vim.g.loaded_gzip = 0
vim.g.loaded_tar = 0
vim.g.loaded_tarPlugin = 0
vim.g.loaded_zip = 0
vim.g.loaded_zipPlugin = 0
vim.g.loaded_getscript = 0
vim.g.loaded_getscriptPlugin = 0
vim.g.loaded_vimball = 0
vim.g.loaded_vimballPlugin = 0
vim.g.loaded_2html_plugin = 0
vim.g.loaded_logiPat = 0
vim.g.loaded_rrhelper = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
vim.g.loaded_netrwSettings = 0
vim.g.loaded_netrwFileHandlers = 0
vim.g.loaded_ruby_provider = 0
--------------------------------------------------------------------------------
-- Message output on vim actions
--------------------------------------------------------------------------------
opt.shortmess:append 'c'
--------------------------------------------------------------------------------
-- Timings
--------------------------------------------------------------------------------
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
--------------------------------------------------------------------------------
-- Window splitting and buffers
--------------------------------------------------------------------------------
opt.splitbelow = true
opt.splitright = true
--------------------------------------------------------------------------------
-- Diff
--------------------------------------------------------------------------------
opt.diffopt = opt.diffopt
  + {
    'vertical',
    'iwhite',
    'algorithm:histogram',
    'indent-heuristic',
  }
--------------------------------------------------------------------------------
-- Format Options
--------------------------------------------------------------------------------
opt.formatoptions = {
  ['1'] = true,
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  o = false, -- Don't continue comments when pressing o/O
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
}
--------------------------------------------------------------------------------
-- (NO)Folds
--------------------------------------------------------------------------------
opt.foldenable = false
--------------------------------------------------------------------------------
-- Wild and file globbing stuff in command mode
--------------------------------------------------------------------------------
opt.wildmode = 'longest:full,full' -- Shows a menu bar as opposed to an enormous list
opt.wildignore = {
  '*.o',
  '*.obj,*~',
  '*node_modules*',
  '**/node_modules/**',
  '*DS_Store*',
  '*.gem',
  'log/**',
  'tmp/**',
}
--------------------------------------------------------------------------------
-- Display
--------------------------------------------------------------------------------
opt.conceallevel = 2
opt.linebreak = true
opt.signcolumn = 'yes:2'
opt.ruler = false
opt.lazyredraw = true
--------------------------------------------------------------------------------
-- List chars
--------------------------------------------------------------------------------
opt.list = true
opt.listchars = {
  tab = '│ ',
  trail = '•',
}

opt.fillchars = {
  vert = '▕', -- alternatives │
}
--------------------------------------------------------------------------------
-- Indentation
--------------------------------------------------------------------------------
opt.textwidth = 80
opt.shiftround = true
opt.shiftwidth = 2
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
--------------------------------------------------------------------------------
-- Utilities
--------------------------------------------------------------------------------
opt.cursorlineopt = 'screenline,number'
opt.pumheight = 15
opt.completeopt = { 'menuone', 'noselect' }
opt.clipboard = { 'unnamedplus' }
opt.termguicolors = true
opt.showmode = false
opt.mouse = 'a'
--------------------------------------------------------------------------------
-- Spelling
--------------------------------------------------------------------------------
opt.spellsuggest:prepend { 12 }
opt.spellcapcheck = ''
--------------------------------------------------------------------------------
-- BACKUP AND SWAPS
--------------------------------------------------------------------------------
opt.backup = false
opt.writebackup = false
opt.swapfile = false
if fn.isdirectory(vim.o.undodir) == 0 then
  fn.mkdir(vim.o.undodir, 'p')
end
opt.undofile = true
--------------------------------------------------------------------------------
-- Match and search
--------------------------------------------------------------------------------
opt.grepprg = 'rg --color=never --no-heading -H -n --column'
opt.gdefault = true
opt.smartcase = true
opt.ignorecase = true
opt.scrolloff = 8
opt.sidescrolloff = 15
opt.sidescroll = 5
