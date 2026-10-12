gwt() {
  local branch="$1"
  if [[ -z $branch ]]; then
    echo "usage: gwt <branch>" >&2
    return 1
  fi

  if [[ $(git rev-parse --is-bare-repository 2>/dev/null) != true ]]; then
    echo "gwt: not inside a bare repository" >&2
    return 1
  fi

  local gitdir
  gitdir=$(cd "$(git rev-parse --git-dir)" && pwd) || return 1
  if [[ $gitdir != *.git ]]; then
    echo "gwt: bare repo '$gitdir' has no .git suffix" >&2
    return 1
  fi

  # Sanitize: anything not alnum . _ - becomes '-', collapse repeats, trim leading/trailing junk
  local name="${branch//[^[:alnum:]._-]/-}"
  name=$(sed -E 's/-+/-/g; s/^[-.]+//; s/-+$//' <<<"$name")

  local target="${gitdir%.git}/$name"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$target" "$branch"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    git worktree add --track -b "$branch" "$target" "origin/$branch"
  else
    echo "gwt: branch '$branch' not found locally or on origin" >&2
    return 1
  fi
}

if [ "$shell" = "bash" ]; then
  _gwt() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local branches
    branches=$(
      {
        git for-each-ref --format='%(refname:lstrip=2)' refs/heads
        git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin
      } 2>/dev/null | grep -vx HEAD | sort -u
    )
    COMPREPLY=($(compgen -W "$branches" -- "$cur"))
  }
  complete -F _gwt gwt
fi

if command -v gwq &>/dev/null; then
  if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
    source <(gwq completion "$shell")
  fi
fi
