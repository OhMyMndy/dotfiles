#!/usr/bin/env bash

sudo mkdir -p /run/sshd
sudo sed -Ei 's/#?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config


echo -e '1234\n1234' | sudo passwd vscode


if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
    mkdir -p ~/.ssh/
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
fi

sudo /usr/bin/sshd -D &

exec "$@"