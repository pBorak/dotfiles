# antibody bundle < ~/code/dotfiles/zsh/configs/plugins.zsh > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh

stty start undef
stty stop undef

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

alias vim="nvim"
alias vi="nvim"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(rbenv init -)"

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"
export -U PATH
