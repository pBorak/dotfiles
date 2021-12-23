#!/usr/bin/zsh

export DOTFILES=$HOME/.dotfiles
export PROJECTS_DIR=$HOME/code

export EDITOR="nvim"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export RIPGREP_CONFIG_PATH=$DOTFILES/rg/.ripgreprc

export FZF_DEFAULT_COMMAND='fd --type f --hidden --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --hidden --color=never'
export FZF_DEFAULT_OPTS='
  --height 75% --multi --reverse --margin=0,1
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind ctrl-a:select-all,ctrl-d:deselect-all
  --color bg+:#24283b,fg+:#dadada,hl:#bb9af7,hl+:#bb9af7
  --color border:#1f2335,info:#e0af68,header:#7aa2f7,spinner:#9ece6a
  --color prompt:#7dcfff,pointer:#f7768e,marker:#545c7e
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

export FUTURE_KISS_CONFIG_PROFILE='local'

export CLOUDSDK_PYTHON=python2
