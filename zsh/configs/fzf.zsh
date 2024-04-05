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
         vim +"Gedit $(echo "$selections" | cut -d' ' -f1 | tr '\n' ' ')"
     fi
 }

fzf_git_branch() {
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf --height 50% "$@" --border --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##' | sed 's#^origin/##'
}

 fzf_github_prs() {
   local selected_pr=$(gh pr list --state all --assignee pborak --limit 200 | fzf --height 50% | awk '{print $1}')

   if [[ -n "$selected_pr" ]]; then
     gh pr view "$selected_pr" -w
   fi
 }
