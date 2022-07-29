alias ..='cd ..'
alias be='bundle exec'
alias c='clear'
alias dbm='dcr bundle exec rails db:migrate'
alias dbmt='dcr bundle exec rails db:migrate RAILS_ENV=test'
alias dbs='dcr bundle exec rails db:migrate:status'
alias dbst='dcr bundle exec rails db:migrate:status RAILS_ENV=test'
alias dc='docker compose'
alias d='docker'
alias dcr='docker compose exec -it rails'
alias dlog='tail -f log/development.log'
alias gb='fzf_git_branch | xargs git checkout'
alias gcurrent="git rev-parse --abbrev-ref HEAD"
alias glS='fzf_git_log_pickaxe'
alias gll='fzf_git_log'
alias gv='gh pr view -w'
alias gva='gh pr list -a pborak -w'
alias l='ls -laFhG'
alias ls='ls -G'
alias rc='dcr bundle exec rails c'
alias rs='be rails s'
alias tf='./base test'
alias tlog='tail -f log/test.log'
alias vi='nvim'
alias vim="nvim"
alias ssh='TERM="xterm-256color" ssh'
