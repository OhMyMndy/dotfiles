test:
	circleci build

link:
	./link.sh

ubuntu:
	./installers/ubuntu.sh

light:
	./installers/xfce.sh --xfce_settings-light

dark:
	./installers/xfce.sh --xfce_settings-dark

keybindings:
	./installers/xfce.sh --xfce_keybindings

build:
	docker-compose -p 'dotfiles' build

run:
	docker-compose -p 'dotfiles' run --rm alpine ash