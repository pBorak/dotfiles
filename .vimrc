" BASICS

" remove all existings autocmds
autocmd!

set nocompatible
set nobackup
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set history=10000               " keep 10000 lines of command line history
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set laststatus=2                " always display the status line
syntax on                       " enable highlighting for syntax 
set showmatch
set number
set relativenumber
" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·
filetype plugin indent on
set wildmode=longest,list,full
" make tab completion for files/buffers act like bash
set wildmenu
" Softtabs, 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" If a file is changed outside of vim, automatically reload it without asking
set autoread
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Diffs are shown side-by-side not above/below
set diffopt=vertical
set signcolumn=no
:set termguicolors
" Completion options.
"   menu: use a popup menu
"   preview: show more info in menu
:set completeopt=menu,preview
set cursorline
" Enable built-in matchit plugin
runtime macros/matchit.vim
" CUSTOM KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map leader key to ','
let mapleader = ','
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100

map <leader>y "+y
map <leader>p "+p

" C-s saves and go to normal mode
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PARDON, My bad
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Q q " Bind :Q to :q
command! E e
command! W w
command! Wq wq


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set t_Co=256 " 256 colors
:color grb24bit

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

