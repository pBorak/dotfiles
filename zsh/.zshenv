#!/usr/bin/zsh

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
export FZF_DEFAULT_OPTS='
  --height 60% --multi --reverse --cycle
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --bind alt-a:toggle-all
  --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
  --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
  --color prompt:#87afff,pointer:#ff5189,marker:#f09479
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
