#!/usr/bin/zsh

export DOTFILES=$HOME/code/dotfiles

export EDITOR="nvim"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export RIPGREP_CONFIG_PATH=$DOTFILES/rg/.ripgreprc

export FZF_DEFAULT_COMMAND='fd --type f --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --color=never'
export FZF_DEFAULT_OPTS='
  --height 75% --multi --reverse --margin=0,1
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind ctrl-a:select-all,ctrl-d:deselect-all
  --color bg+:#262626,fg+:#dadada,hl:#ae81ff,hl+:#ae81ff
  --color border:#303030,info:#cfcfb0,header:#74b2ff,spinner:#36c692
  --color prompt:#87afff,pointer:#ff5189,marker:#7c8f8f
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

export FUTURE_KISS_CONFIG_PROFILE='local'

export CLOUDSDK_PYTHON=python2
