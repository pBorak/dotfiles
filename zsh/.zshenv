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
  --color=fg:#cdcdcd \
  --color=bg:#141415 \
  --color=hl:#f3be7c \
  --color=fg+:#aeaed1 \
  --color=bg+:#252530 \
  --color=hl+:#f3be7c \
  --color=border:#606079 \
  --color=header:#6e94b2 \
  --color=gutter:#141415 \
  --color=spinner:#7fa563 \
  --color=info:#f3be7c \
  --color=pointer:#aeaed1 \
  --color=marker:#d8647e \
  --color=prompt:#bb9dbd
"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export PATH="$HOME/.local/bin:$PATH"
