#!/usr/bin/zsh

export DOTFILES=$HOME/.dotfiles
export PROJECTS_DIR=$HOME/code
export ZSH_PLUGINS_DIR=$HOME/.zsh/plugins

export EDITOR="nvim"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME=tokyo

export RIPGREP_CONFIG_PATH=$DOTFILES/rg/.ripgreprc

export FZF_DEFAULT_COMMAND='fd --type f --hidden --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --hidden --color=never'
export FZF_DEFAULT_OPTS='
  --height 75% --multi --reverse --margin=0,1
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind ctrl-a:select-all,ctrl-d:deselect-all
  --color=bg+:#2f334d,bg:#080808,spinner:#7a88cf,hl:#ff757f
  --color=fg:#c8d3f5,header:#ff757f,info:#c099ff,pointer:#545c7e
  --color=marker:#545c7e,fg+:#c8d3f5,prompt:#c099ff,hl+:#ff757f
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
