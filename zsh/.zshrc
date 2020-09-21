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
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --line-range :500 {}"'

eval "$(rbenv init -)"
