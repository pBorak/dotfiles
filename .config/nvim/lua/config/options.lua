vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local opt = vim.opt

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

opt.shortmess:append({ C = true })
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'
opt.diffopt = opt.diffopt
  + {
    'vertical',
    'algorithm:histogram',
    'indent-heuristic',
    'linematch:60',
  }
opt.formatoptions = 'jcroqlnt' -- tcqj
opt.foldenable = false
opt.wildmode = 'longest:full,full' -- Shows a menu bar as opposed to an enormous list
opt.conceallevel = 2
opt.linebreak = true
opt.signcolumn = 'yes'
opt.ruler = false
opt.laststatus = 3
opt.list = true
opt.listchars = {
  tab = '│ ',
  trail = '•',
}
opt.textwidth = 80
opt.shiftround = true
opt.shiftwidth = 2
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.cursorlineopt = 'screenline,number'
opt.cursorline = true
opt.pumheight = 15
opt.completeopt = { 'menuone', 'noselect' }
opt.clipboard = { 'unnamedplus' }
opt.termguicolors = true
opt.showmode = false
opt.mouse = 'a'
opt.spelloptions:append({ 'noplainbuffer' })
opt.spellsuggest:prepend({ 12 })
opt.spellcapcheck = ''
opt.backup = false
opt.writebackup = false
opt.swapfile = false
if vim.fn.isdirectory(vim.o.undodir) == 0 then vim.fn.mkdir(vim.o.undodir, 'p') end
opt.undofile = true
opt.grepprg = 'rg --color=never --no-heading -H -n --column'
opt.gdefault = true
opt.smartcase = true
opt.ignorecase = true
opt.scrolloff = 8
opt.sidescrolloff = 15
opt.sidescroll = 5
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
require('util.abbreviations')
