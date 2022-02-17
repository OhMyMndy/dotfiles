# shellcheck shell=sh

export PATH="$HOME/bin:$HOME/.go/bin:$HOME/.cargo/bin:$PATH:$HOME/.gem/bin:$HOME/.local/bin:$HOME/.composer/vendor/bin"

if command -v ruby &>/dev/null && command -v gem &>/dev/null; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
