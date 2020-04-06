set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=
source ~/.vimrc
