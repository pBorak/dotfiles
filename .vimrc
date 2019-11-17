" BASICS

set encoding=utf-8

" remove all existings autocmds
autocmd!



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'thoughtbot/vim-rspec'
Plug 'vim-ruby/vim-ruby'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-conflicted'
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
call plug#end()


set nocompatible
set backupdir=~/.tmp
set directory=~/.tmp            " Don't clutter my dirs up with swp and tmp files
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
:set termguicolors
" Completion options.
"   menu: use a popup menu
"   preview: show more info in menu
:set completeopt=menu,preview
set cursorline
" Enable built-in matchit plugin
runtime macros/matchit.vim
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
" Ignore stuff that can't be opened
set wildignore+=tmp/**
" Run specs in vim dispatch
let g:rspec_command = "Dispatch bundle exec rspec {spec}"
" Fix mouse tmux issue
set ttymouse=xterm2
set mouse=a
"Store ctags in .git folder
set tags =.git/tags
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " User ag for ack.vim
  let g:ackprg = 'ag --nogroup --nocolor --column'
  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'
  let g:fzf_files_options =
        \ '--reverse ' .
        \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Ruby-vim configuration
:let g:ruby_indent_block_style = 'do'
:let g:ruby_indent_assigment_style = 'veriable'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map leader key to ','
let mapleader = ','
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" Execute macro in q
map Q @q

map <leader>y "+y
map <leader>p "+p

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FZF MAPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-p> :Files<cr>
nnoremap <Leader>ga :Files app/<cr>
nnoremap <Leader>gm :Files app/models/<cr>
nnoremap <Leader>gv :Files app/views/<cr>
nnoremap <Leader>gc :Files app/controllers/<cr>
nnoremap <Leader>gt :Files spec/<cr>

nmap 0 ^
nmap k gk
nmap j gj
nnoremap Y  y$

" C-s saves and go to normal mode
nnoremap <C-s> <esc>:noh<cr>:w<cr>
vnoremap <C-S> <esc>gV
onoremap <C-S> <esc>
cnoremap <C-S> <C-c>
inoremap <C-s> <esc>:w<cr>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
map <leader>o :only<cr>
" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Rspec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<cr>
map <Leader>l :call RunLastSpec()<cr>
map <Leader>a :call RunAllSpecs()<cr>
map <Leader>s :call RunNearestSpec()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ACK
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>f :Ack!<space>

function! s:VisualAck()
  let temp = @"
  normal! gvy
  let escaped_pattern = escape(@", "[]().*")
  let @" = temp
  execute "Ack! '" . escaped_pattern . "'"
endfunction

nnoremap K :Ack! '<C-r><C-w>'<cr>
vnoremap K :<C-u>call <sid>VisualAck()<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickfix
map <Leader>Q :cc<cr>
map <space><space> :ccl<cr>
map <Leader>q :copen<cr><cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PARDON, My bad
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Q q " Bind :Q to :q
command! E e
command! W w
command! Wq wq
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"RAILS-VIM FAST ACCESS MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>vc :Vcontroller<cr>
map <Leader>vm :Vmodel<cr>
map <Leader>vv :Vview<cr>

" EDIT ANOtHER FILE IN THE SAME DIR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<cr>
map <Leader>vs :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<cr>

" Fugitivie mappings
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <leader>gnc :GitNextConflict<cr>

" Don't automatically continue comments after newline
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,sass,cucumber set ai sw=2 sts=2 et
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
augroup end
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set t_Co=256 " 256 colors
:color grb24bit
highlight ColorColumn ctermbg=235 guibg=#2c2d27
" Set gutter background to black
highlight SignColumn ctermbg=black guibg=#2c2d27
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set stl+=%{ConflictedVersion()}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SQUASH ALL COMMITS INTO THE FIRST ONE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SquashAll()
  normal ggj}klllcf:w
endfunction
command! SquashAll :call SquashAll()
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
" MULTIPURPOSE TAB KEY
" INDENT IF WE'RE AT THE BEGINNING OF A LINE. ELSE, DO COMPLETION.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col
    return "\<tab>"
  endif

  let char = getline('.')[col - 1]
  if char =~ '\k'
    " There's an identifier before the cursor, so complete the identifier.
    return "\<c-p>"
  else
    return "\<tab>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM - ALE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = { 'javascript': ['eslint'], 'ruby': ['rubocop', 'ruby'] }
let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0
nmap <silent> [r <Plug>(ale_previous_wrap)
nmap <silent> ]r <Plug>(ale_next_wrap)
let g:ale_ruby_rubocop_executable = 'bundle'
