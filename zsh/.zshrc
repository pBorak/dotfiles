source ~/.zplug/init.zsh

zplug 'mafredri/zsh-async'
zplug 'sindresorhus/pure'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-completions', defer:2

zplug load

stty start undef
stty stop undef

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

ensure_tmux_is_running

alias vim="nvim"
alias vi="nvim"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
