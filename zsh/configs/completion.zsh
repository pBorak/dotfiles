fpath=(~/.zsh/completion $fpath)

autoload -U compinit

compinit

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' expand suffix
zstyle ':completion:*' list-suffixes true

# case-insensitive (all), partial-word and then substring completion
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
