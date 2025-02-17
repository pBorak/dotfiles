#!/usr/bin/zsh

export XDG_CONFIG_HOME="$HOME/.config"
export DOTFILES=$HOME/.dotfiles
export PROJECTS_DIR=$HOME/code
export ZSH_PLUGINS_DIR=$HOME/.zsh/plugins

export EDITOR="nvim"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME=fly16

export RIPGREP_CONFIG_PATH=$DOTFILES/rg/.ripgreprc

export FZF_DEFAULT_COMMAND='fd --type f --hidden --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --hidden --color=never'
export FZF_DEFAULT_OPTS="\
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color bg:#080808 \
  --color bg+:#262626 \
  --color border:#2e2e2e \
  --color fg:#b2b2b2 \
  --color fg+:#e4e4e4 \
  --color gutter:#262626 \
  --color header:#80a0ff \
  --color hl+:#f09479 \
  --color hl:#f09479 \
  --color info:#cfcfb0 \
  --color marker:#f09479 \
  --color pointer:#ff5189 \
  --color prompt:#80a0ff \
  --color spinner:#36c692
"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
