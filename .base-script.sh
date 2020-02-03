#!/usr/bin/env bash

set -eu

this_command=''
previous_command=''
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
finish() {
	>&2 echo "Error while executing '$previous_command' in $0"
	exit $?
}
trap "finish" ERR
trap "exit" INT

if command -v git &> /dev/null; then
	ROOT_DIR="$(git rev-parse --show-toplevel)"
fi

# shellcheck source=../.functions
source "$ROOT_DIR/.functions"