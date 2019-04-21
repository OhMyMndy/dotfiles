#!/usr/bin/env bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d ~/.oh-my-zsh/lib ]; then
    rm -rf ~/.oh-my-zsh/
    cd /tmp
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
    sed -i.tmp 's:env zsh::g' install.sh
    sed -i.tmp 's:chsh -s .*$::g' install.sh
    sh install.sh
    rm install.sh
fi

# sed -Ei 's#ZSH_THEME.*#ZSH_THEME="af-magic"#g' ~/.zshrc


# Change shell
# chsh -s /bin/zsh $(whoami)

function installZshPlugin() {
	pluginUrl="$1"
	pluginDir="$2"

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$pluginDir" ]; then
		echo "Installing ZSH plugin '$pluginDir'"
		git clone $pluginUrl ~/.oh-my-zsh/custom/plugins/$pluginDir
	else
		echo "ZSH plugin '$pluginDir' is already installed"
	fi

}

mkdir -p ~/.oh-my-zsh/custom/themes
ln -sf $DIR/../.oh-my-zsh/custom/themes/mandy.zsh-theme ~/.oh-my-zsh/custom/themes/mandy.zsh-theme


installZshPlugin "git://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
installZshPlugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
installZshPlugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
installZshPlugin "https://github.com/junegunn/fzf.git" "fzf"
installZshPlugin "https://github.com/marzocchi/zsh-notify.git" "notify"
~/.oh-my-zsh/custom/plugins/fzf/install --bin

installZshPlugin "https://github.com/Treri/fzf-zsh.git" "fzf-zsh"