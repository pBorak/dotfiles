""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-moonfly-statusline'
Plug 'christoomey/vim-conflicted'
Plug 'christoomey/vim-system-copy'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'rhysd/clever-f.vim'
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
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/ReplaceWithRegister'

let g:coc_global_extensions = [
      \ 'coc-flow',
      \ 'coc-snippets',
      \]
call plug#end()

" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set gdefault
set showmatch
set inccommand=nosplit
set number
set relativenumber
" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·
set wildmode=longest,list,full
" Softtabs, 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Diffs are shown side-by-side not above/below
set diffopt+=vertical
set completeopt=menu,menuone,noinsert,noselect
set cursorline
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
" Ignore stuff that can't be opened
set wildignore+=tmp/**
set mouse=a
"Store ctags in .git folder
set tags =.git/tags
set grepprg=rg\ --vimgrep\ --smart-case
" User rg for ack.vim
let g:ackprg = 'rg --vimgrep --smart-case'

let $FZF_DEFAULT_COMMAND = 'rg --files -g "" --hidden'
let g:fzf_files_options =
      \ '--reverse ' .
      \ '--preview "(bat -style full --decorations always --color always {} ' .
      \ '|| cat {}) 2> /dev/null | head -'.&lines.'" '.
      \ '--preview-window right:60%'
let g:fzf_layout = { 'window': {
      \ 'width': 0.9,
      \ 'height': 0.7,
      \ 'highlight': 'fzfBorder',
      \ 'border': 'sharp' } }
let g:fzf_commits_log_options = '--color=always
 \ --date=human --format="%C(#e3d18a)%h%C(#fc514e)%d%C(reset)
 \ - %C(#21c7a8	)(%ad)%C(reset) %s %C(#80a0ff){%an}%C(reset)"'

nnoremap <C-f> :Rg<space>

function! s:VisualAck()
  let temp = @"
  normal! gvy
  let escaped_pattern = escape(@", "[]().*")
  let @" = temp
  execute "Ack! '" . escaped_pattern . "'"
endfunction

vnoremap K :<C-u>call <sid>VisualAck()<cr>
nnoremap K :Rg <C-R><C-W><CR>

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Ruby-vim configuration
:let g:ruby_indent_block_style = 'do'
:let g:ruby_indent_assigment_style = 'veriable'

" Clever f
let g:clever_f_across_no_line    = 1
let g:clever_f_fix_key_direction = 1
let g:clever_f_mark_cursor       = 1
let g:clever_f_mark_cursor_color = 'IncSearch'

" Splitjoin 
let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_ruby_hanging_args = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM KEY MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" Execute macro in q
map Q @q

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FZF MAPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <Leader>gm :Files app/models/<cr>
nnoremap <silent> <Leader>gv :Files app/views/<cr>
nnoremap <silent> <Leader>gc :Files app/controllers/<cr>
nnoremap <silent> <Leader>gt :Files spec/<cr>
nnoremap <silent> <Leader>gl :Commits<cr>
nnoremap <silent> <Leader>bl :BCommits<cr>
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>

nmap 0 ^
nmap k gk
nmap j gj
nnoremap Y  y$

nnoremap <silent> <Esc> <Esc>:noh<cr>
nnoremap <leader>w :w<cr>

nnoremap <leader>cc :cclose<cr>:pclose<cr>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
map <leader>o :only<cr>
" Switch between the last two files
nnoremap <Leader><Leader> <C-^>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt

let test#strategy = "vtr"
map <silent> <Leader>t :TestFile<cr>
map <silent> <Leader>l :TestLast<cr>
map <silent> <Leader>a :TestSuite<cr>
map <silent> <Leader>s :TestNearest<cr>

" Debugging

nnoremap <leader>bp orequire "pry"; binding.pry<esc>
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
noremap <C-s> :VtrSendLinesToRunner<cr>
nnoremap <leader>ss :VtrSendCommandToRunner<space>

" Fugitivie mappings
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>d :Gdiff<cr>
nnoremap <leader>gnc :GitNextConflict<cr>

noremap ; :

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
let g:moonflyWithGitBranchCharacter = 1
let g:moonflyWithCocIndicator = 1
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

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

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
    call CocActionAsync('doHover')
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

nmap <leader>rr <Plug>(coc-codeaction)
" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
nnoremap <leader>f :CocSearch <C-R>=expand("<cword>")<CR><CR>

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'


let g:javascript_plugin_flow = 1
