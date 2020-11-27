alias ..='cd ..'
alias be='bundle exec'
alias c='clear'
alias dbm='be rails db:migrate'
alias dbmt='be rails db:migrate RAILS_ENV=test'
alias dbs='be rails db:migrate:status'
alias dbst='be rails db:migrate:status RAILS_ENV=test'
alias dlog='tail -f log/development.log'
alias gv='gh pr view -w'
alias gva='gh pr list -a pborak -w'
alias gpr='gh pr create -a pborak -r zendesk/sell-growth -f'
alias l='ls -laFhG'
alias ls='ls -G'
alias rc='be rails c'
alias rg='rg --smart-case'
alias rs='be rails s'
alias tf='./base test'
alias tlog='tail -f log/test.log'
alias vi='nvim'
alias vrc='nvim ~/code/dotfiles/.init.vim'
alias glS='fzf_git_log_pickaxe'
alias gll='fzf_git_log'
alias ga='fzf_git_add'
alias gb='fzf_git_branch | xargs git checkout'
