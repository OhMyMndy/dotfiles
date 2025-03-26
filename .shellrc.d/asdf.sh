# Make sure we use asdf versions of tools before tools installed on the
# OS or via Nix

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

if [ -n "$BASH" ] && command -v asdf &>/dev/null; then
	. <(asdf completion bash)
fi
