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
" Unmap K dosc entirely
nnoremap K <Nop>

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

" Don't automatically continue comments after newline
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set t_Co=256 " 256 colors
:color grb24bit

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Squash all commits into the first one
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SquashAll()
  normal ggj}klllcf:w
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Edit another file in the same dir
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
map <Leader>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <Leader>v :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
