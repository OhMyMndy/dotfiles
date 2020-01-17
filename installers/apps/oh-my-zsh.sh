#!/usr/bin/env bash

trap "exit" INT

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d ~/.oh-my-zsh/lib ]; then
    rm -rf ~/.oh-my-zsh/
    cd /tmp || exit 2
	# shellcheck disable=SC2216
    yes n | locale
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
    sed -i.tmp 's:env zsh::g' install.sh
    sh install.sh
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
		git clone "$pluginUrl" "$HOME/.oh-my-zsh/custom/plugins/$pluginDir"
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
~/.oh-my-zsh/custom/plugins/fzf/install --bin

find ~/.oh-my-zsh/plugins -maxdepth 1 -type d ! -path . -print0 | xargs -0 -r -i bash -c "cd {}; git pull"

# installZshPlugin "https://github.com/Treri/fzf-zsh.git" "fzf-zsh"
