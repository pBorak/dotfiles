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
  --height 60% --multi --reverse --cycle
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind alt-a:toggle-all
  --color=bg+:#3654a7,bg:#080808,spinner:#7a88cf,hl:#65bcff,gutter:#080808
  --color=fg:#c8d3f5,header:#65bcff,info:#65bcff,pointer:#65bcff
  --color=marker:#ff966c,fg+:#c8d3f5,prompt:#65bcff,hl+:#65bcff
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
