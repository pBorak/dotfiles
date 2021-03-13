export FZF_DEFAULT_COMMAND='fd --type f --color=never'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d . --color=never'
export FZF_DEFAULT_OPTS='
  --height 75% --multi --reverse --margin=0,1
  --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up
  --color bg+:#262626,fg+:#dadada,hl:#ae81ff,hl+:#ae81ff
  --color border:#303030,info:#cfcfb0,header:#74b2ff,spinner:#36c692
  --color prompt:#87afff,pointer:#ff5189,marker:#7c8f8f
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

fzf_git_add() {
    local selections=$(
      git status --porcelain | \
      fzf --ansi \
          --preview 'if (git ls-files --error-unmatch {2} &>/dev/null); then
                         git diff --color=always {2} | delta
                     else
                         bat --color=always --line-range :500 {2}
                     fi'
      )
    if [[ -n $selections ]]; then
        git add --verbose $(echo "$selections" | cut -c 4- | tr '\n' ' ')
    fi
}

fzf_git_log() {
    local selections=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --no-height \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @' |
                       delta"
      )
    if [[ -n $selections ]]; then
        git show $(echo "$selections" | sed 's/^[* |]*//' | cut -d' ' -f1 | tr '\n' ' ')
    fi
}

fzf_git_log_pickaxe() {
     if [[ $# == 0 ]]; then
         echo 'Error: search term was not provided.'
         return
     fi
     local selections=$(
       git log --oneline --color=always -S "$@" |
         fzf --ansi --no-sort --no-height \
             --preview "git show --color=always {1} | delta"
       )
     if [[ -n $selections ]]; then
         git show $(echo "$selections" | cut -d' ' -f1 | tr '\n' ' ')
     fi
 }

fzf_git_branch() {
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf --height 50% "$@" --border --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##' | sed 's#^origin/##'
}
