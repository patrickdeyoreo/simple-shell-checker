#!/usr/bin/env bash
#
# Run a test suite for the Holberton shell project


set -o errexit

SOURCE_DIR=$(realpath -- "$(dirname -- "${BASH_SOURCE%/*}")")

OUTPUT_DIR=$(mktemp -d --tmpdir -- "${BASH_SOURCE##*/}-XXX")

trap -- 'rm -rf "${OUTPUT_DIR}"' EXIT

source -- "${SOURCE_DIR}"/libmsg.sh

source -- "${SOURCE_DIR}"/libtest.sh

set +o errexit


if (( $# != 1 )); then
    msg::error "${0##*/}" 'usage' "${BASH_SOURCE##*/} SHELL"
    exit 1
fi
if ! [[ -e $1 ]]; then
    msg::error "${0##*/}" "$1" 'No such file or directory'
    exit 1
fi
if ! [[ -r $1 && -x $1 ]]; then
    msg::error "${0##*/}" "$1" 'Permission denied'
    exit 1
fi


SHELL=$(realpath -- "$1")

cd -- "${OUTPUT_DIR}"

test::all "${SOURCE_DIR}"/tasks


# vi:et:ft=sh:sts=4:sw=4
