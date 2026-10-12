
_gwt() {
  local -a branches
  branches=(${(f)"$(
    {
      git for-each-ref --format='%(refname:lstrip=2)' refs/heads
      git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin
    } 2>/dev/null | grep -vx HEAD | sort -u
  )"})
  compadd -a branches
}
compdef _gwt gwt
