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
