shell=$([ -n "${BASH_VERSION:-}" ] && echo bash || { [ -n "${ZSH_VERSION:-}" ] && echo zsh; } || basename "$(readlink /proc/$$/exe 2>/dev/null)")
export shell
if [ -d ~/.shellrc.d ]; then
  for rc in ~/.shellrc.d/*; do
    if [ -f "$rc" ]; then
      # shellcheck disable=SC1090
      . "$rc"
    fi
  done
fi

if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      # shellcheck disable=SC1090
      . "$rc"
    fi
  done
fi
