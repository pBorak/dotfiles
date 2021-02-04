compdef g=git
function g {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}
compdef _git gro=git-rebase
function gro() { git rebase --onto $1 $2 $(gcurrent) }
