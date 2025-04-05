# Make sure we use asdf versions of tools before tools installed on the
# OS or via Nix
if ! grep -q "asdf" <<< "$PATH"; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi
if [ -n "$BASH" ] && command -v asdf &>/dev/null; then
	. <(asdf completion bash)
fi
