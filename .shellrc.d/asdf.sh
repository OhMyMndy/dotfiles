# Make sure we use asdf versions of tools before tools installed on the
# OS or via Nix
if [[ -d ~/.asdf/shims ]]; then
  export PATH="$HOME/.asdf/shims:$PATH"
fi
if command -v asdf &>/dev/null; then
  if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
    . <(asdf completion "$shell")
  fi
fi
