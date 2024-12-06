# Remove flow control and make <C-s> work in shell
stty start undef
stty stop undef

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#-------------------------------------------------------------------------------
#  Plugins
#-------------------------------------------------------------------------------
source $ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGINS_DIR/powerlevel10k/powerlevel10k.zsh-theme
#-------------------------------------------------------------------------------
#  Source config files
#-------------------------------------------------------------------------------
for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done
#-------------------------------------------------------------------------------
#  Source work files
#-------------------------------------------------------------------------------
source ~/.work_zshrc.zsh
#-------------------------------------------------------------------------------
#  Init dependencies
#-------------------------------------------------------------------------------
. /opt/homebrew/opt/asdf/libexec/asdf.sh
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
