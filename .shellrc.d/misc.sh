if command -v rbw &>/dev/null; then
  if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
    source <(rbw gen-completions "$shell")
  fi
fi
if command -v atuin &>/dev/null; then
  if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
    eval "$(atuin init --disable-up-arrow "$shell")"
  fi
fi
