#!/usr/bin/env bash

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
# shellcheck source=../../.base-script.sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../.base-script.sh"

if [ ! -d ~/.oh-my-zsh/lib ]; then
    rm -rf ~/.oh-my-zsh/

    cd "${TMPDIR}" || exit 2
	# shellcheck disable=SC2216
    yes n | locale
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
    sed -i -E 's#exec zsh.*##g' install.sh
    yes | bash install.sh
    rm install.sh
fi

# sed -Ei 's#ZSH_THEME.*#ZSH_THEME="af-magic"#g' ~/.zshrc


# Change shell
# chsh -s /bin/zsh $(whoami)

function installZshPlugin() {
	pluginUrl="$1"
	pluginDir="$2"

	if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/$pluginDir" ]]; then
		echo "Installing ZSH plugin '$pluginDir'"
		git clone -q "$pluginUrl" "$HOME/.oh-my-zsh/custom/plugins/$pluginDir"
	fi

}

mkdir -p ~/.oh-my-zsh/custom/themes
ln -sf "$DIR/../../.oh-my-zsh/custom/themes/mandy.zsh-theme" ~/.oh-my-zsh/custom/themes/mandy.zsh-theme

installZshPlugin "git://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
installZshPlugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
installZshPlugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
installZshPlugin "https://github.com/junegunn/fzf.git" "fzf"
installZshPlugin "https://github.com/marzocchi/zsh-notify.git" "notify"
installZshPlugin "https://github.com/Aloxaf/fzf-tab" "fzf-tab"
if [[ ! -f "$HOME/.fzf/bin/fzf" ]]; then
	~/.oh-my-zsh/custom/plugins/fzf/install --bin
fi

cd ~/.oh-my-zsh/ && git pull -q
find ~/.oh-my-zsh/custom/plugins -maxdepth 1 -type d ! -path . -print0 | xargs -0 -r -i bash -c "cd {}; git pull -q"
