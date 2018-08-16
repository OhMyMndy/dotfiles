#!/usr/bin/env bash

if [ ! -d ~/.oh-my-zsh/lib ]; then
    rm -rf ~/.oh-my-zsh/
    cd /tmp
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
    sed -i.tmp 's:env zsh::g' install.sh
    sed -i.tmp 's:chsh -s .*$::g' install.sh
    sh install.sh
    rm install.sh
fi

sed -Ei 's#ZSH_THEME.*#ZSH_THEME="af-magic"#g' ~/.zshrc


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

installZshPlugin "git://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
installZshPlugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
installZshPlugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
installZshPlugin "https://github.com/jimeh/zsh-peco-history.git" "zsh-peco-history"
sed -i -e's/\s*BUFFER=.*/BUFFER=$\(fc -l -n 1 |  eval $tac | awk "\!x\[\\$0\]++" | \\/' ~/.oh-my-zsh/custom/plugins/zsh-peco-history/zsh-peco-history.zsh


installZshPlugin "https://github.com/skx/sysadmin-util.git" "sysadmin-util"