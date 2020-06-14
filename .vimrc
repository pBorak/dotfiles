""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pBorak/vim-nightfly-guicolors'
Plug 'christoomey/vim-conflicted'
Plug 'christoomey/vim-system-copy'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'itchyny/lightline.vim'
Plug 'janko/vim-test'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user'
Plug 'Krasjet/auto.pairs'
Plug 'leafgarland/typescript-vim'
Plug 'mattn/emmet-vim'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pangloss/vim-javascript'
Plug 'pbrisbin/vim-mkdir'
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript.jsx' }
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/ReplaceWithRegister'

let g:coc_global_extensions = [ 'coc-flow' ]
call plug#end()

set nocompatible
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
set inccommand=nosplit
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
set diffopt+=iwhite
set diffopt+=vertical
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
        \ '--preview "(bat -style full --decorations always --color always {} ' .
        \ '|| cat {}) 2> /dev/null | head -'.&lines.'" '.
        \ '--preview-window right:60%'
  let g:fzf_layout = { 'window': {
        \ 'width': 0.8,
        \ 'height': 0.5,
        \ 'highlight': 'Statement',
        \ 'border': 'sharp' } }

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
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
nnoremap <leader>w1 1gt
nnoremap <leader>w2 2gt
nnoremap <leader>w3 3gt
nnoremap <leader>w4 4gt

let test#strategy = "vtr"
map <silent> <Leader>t :TestFile<cr>
map <silent> <Leader>l :TestLast<cr>
map <silent> <Leader>a :TestSuite<cr>
map <silent> <Leader>s :TestNearest<cr>

" Debugging

nnoremap <leader>bp orequire "pry"; binding.pry<esc>

" EasyAlign

vmap <cr> <Plug>(EasyAlign)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ACK
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:VisualAck()
  let temp = @"
  normal! gvy
  let escaped_pattern = escape(@", "[]().*")
  let @" = temp
  execute "Ack! '" . escaped_pattern . "'"
endfunction

nnoremap K :Ack! '<C-r><C-w>'<cr>
vnoremap K :<C-u>call <sid>VisualAck()<cr>
map <Leader>k :Ack!<space>
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
command! Vs vs
" EDIT ANOtHER FILE IN THE SAME DIR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<cr>
map <Leader>vs :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VTR commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>v- :VtrOpenRunner { "orientation": "v", "percentage": 30 }<cr>
nnoremap <leader>v\ :VtrOpenRunner { "orientation": "h", "percentage": 30 }<cr>
nnoremap <leader>vk :VtrKillRunner<cr>
nnoremap <leader>va :VtrAttachToPane<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
noremap <C-f> :VtrSendLinesToRunner<cr>
nnoremap <leader>ss :VtrSendCommandToRunner<space>

" Fugitivie mappings
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>d :Gdiff<cr>
nnoremap <leader>gnc :GitNextConflict<cr>

:let g:user_emmet_leader_key = '<c-e>'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  autocmd FileType gitcommit setlocal spell
" Don't automatically continue comments after newline
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
augroup end
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors

colorscheme nightfly
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Light line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'nightfly',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }
set noshowmode
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
" don't give |ins-completion-menu| messages.
set shortmess+=c

set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
set noswapfile

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <tab> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <TAB> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<TAB>"

" Use `[r` and `]r` to navigate diagnostics
nmap <silent> [r <Plug>(coc-diagnostic-prev)
nmap <silent> ]r <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gh <Plug>(coc-references)

" show documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> S :call <SID>show_documentation()<CR>

" show error, otherwise documentation, on hold
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#util#has_float() == 0)
    silent call CocActionAsync('doHover')
  endif
endfunction
function! s:show_hover_doc()
  call timer_start(200, 'ShowDocIfNoDiagnostic')
endfunction
autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

" common editor actions
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>fo <Plug>(coc-format-selected)
nmap <leader>fo <Plug>(coc-format-selected)

augroup cocgroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Show all diagnostics
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
" Show commands
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols - not working with flow
" nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

let g:javascript_plugin_flow = 1
