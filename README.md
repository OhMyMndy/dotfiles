# Dotfiles

[![CircleCI](https://circleci.com/gh/Mandy91/dotfiles.svg?style=svg)](https://circleci.com/gh/Mandy91/dotfiles)

## Ubuntu

```bash
sudo apt-get update -qq; sudo apt-get install git vim curl -y -qq
cd ~
git clone -q https://github.com/mandy91/dotfiles.git

~/dotfiles/link.sh
~/dotfiles/installers/ubuntu.sh --minimal --general --locale --upgrade --autostart --settings --settings-light
~/dotfiles/link.sh
```

## Termux

```bash
apt install openssh zsh git vim tmux wget curl ruby -y
cd ~
git clone -q https://github.com/mandy91/dotfiles.git
```

## Development

Install `pre-commit`
Run `pre-commit install` to set up the git hooks
