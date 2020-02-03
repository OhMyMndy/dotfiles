#!/usr/bin/env bash

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
# shellcheck source=../.base-script.sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.base-script.sh"

if [[ $UID -eq 0 ]]; then
	echo "Run this script as non root user please..."
	exit 99
fi

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