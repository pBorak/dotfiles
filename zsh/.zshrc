# Remove flow control and make <C-s> work in shell
stty start undef
stty stop undef

sz() { source ~/.zshrc }
#-------------------------------------------------------------------------------
#  Plugins
#-------------------------------------------------------------------------------
# antibody bundle < ~/code/dotfiles/zsh/configs/plugins.zsh > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh
#-------------------------------------------------------------------------------
#  Colors
#-------------------------------------------------------------------------------
# makes color constants available
autoload -U colors
colors
# enable colored output from ls, etc. on FreeBSD-based systems
export CLICOLOR=1
#-------------------------------------------------------------------------------
#  Source config files
#-------------------------------------------------------------------------------
for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done
#-------------------------------------------------------------------------------
#  Init dependencies
#-------------------------------------------------------------------------------
eval "$(rbenv init -)"
eval "$(zoxide init --cmd cd zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi
#-------------------------------------------------------------------------------
#  Google cloud sdk
#-------------------------------------------------------------------------------
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
