#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive

# to test this script: `docker run --rm -v "${PWD}:${PWD}:ro" -it "ubuntu-mandy:0.1-20.04" -c "$PWD/installers/ubuntu.sh --ulauncher"`

trap "exit" INT


if [[ $UID -eq 0 ]]; then
	echo "Run this script as non root user please..."
	exit 99
fi

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
ROOT_DIR="$DIR/../"

# shellcheck source=../.functions
source "$ROOT_DIR/.functions"

set -e
if is_mac; then
    # shellcheck source=./osx.sh
    "$DIR/osx.sh"
elif is_ubuntu; then
    # shellcheck source=./ubuntu.sh
    "$DIR/ubuntu.sh"
elif is_android; then
    # shellcheck source=./termux.sh
    "$DIR/termux.sh"
fi


# shellcheck source=../link.sh
"$ROOT_DIR/link.sh"