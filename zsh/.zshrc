# antibody bundle < ~/code/dotfiles/zsh/configs/plugins.zsh > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh

stty start undef
stty stop undef

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

alias vim="nvim"
alias vi="nvim"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(rbenv init -)"
