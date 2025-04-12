# Make sure we use asdf versions of tools before tools installed on the
# OS or via Nix
if [[ -d ~/.asdf/shims ]]; then
  export PATH="$HOME/.asdf/shims:$PATH"
fi
if [ -n "$BASH" ] && command -v asdf &>/dev/null; then
	. <(asdf completion bash)
fi
