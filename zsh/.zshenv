#!/usr/bin/zsh

export DOTFILES=$HOME/.dotfiles
export PROJECTS_DIR=$HOME/code
export ZSH_PLUGINS_DIR=$HOME/.zsh/plugins

export EDITOR="nvim"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME=catppuccin

export RIPGREP_CONFIG_PATH=$DOTFILES/rg/.ripgreprc

export FZF_DEFAULT_COMMAND='fd --type f --hidden --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --hidden --color=never'
export FZF_DEFAULT_OPTS='
  --height 75% --multi --reverse --margin=0,1
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind ctrl-a:select-all,ctrl-d:deselect-all
  --color=bg+:#313244,bg:#000000,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
