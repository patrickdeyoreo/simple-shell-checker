#!/usr/bin/env bash
#
# Run a test suite for the Holberton shell project


set -o errexit

USAGE="${BASH_SOURCE##*/} [-r REPO] [-s SHELL]"

SOURCE_DIR=$(CDPATH= cd -- "${BASH_SOURCE%/*}" && pwd -P)

OUTPUT_DIR=$(mktemp -d --tmpdir -- "${BASH_SOURCE##*/}-XXX")

trap -- 'rm -rf "${OUTPUT_DIR}"' EXIT


source -- "${SOURCE_DIR}/config.sh"

source -- "${SOURCE_DIR}/libmsg.sh"

source -- "${SOURCE_DIR}/libref.sh"

source -- "${SOURCE_DIR}/libtest.sh"


declare -A opts=( )

ref::getopts opts 'r:s:h' "$@"

shift "$((OPTIND - 1))"


if [[ -n ${opts[r]+_} ]]
then
    REPO="${opts[r]}"
fi

if [[ -n ${opts[s]+_} ]]
then
    SHELL="${opts[s]}"
fi

if [[ -n ${opts[h]+_} ]]
then
    msg::std "${0##*/}" 'usage' "${USAGE}"
    exit 2
fi

set +o errexit


if (( $# ))
then
    msg::error "${0##*/}" 'too many arguments'
    exit 1
fi

if ! [[ -n ${SHELL} ]]
then
    msg::error "${0##*/}" 'SHELL' 'must be non-null'
    exit 1
fi

if ! [[ -e ${SHELL} ]]
then
    msg::error "${0##*/}" "$1" 'No such file or directory'
    exit 1
fi

if ! [[ -r ${SHELL} && -x ${SHELL} ]]
then
    msg::error "${0##*/}" "$1" 'Permission denied'
    exit 1
fi


test::all "${SOURCE_DIR}/tasks"


# vi:et:ft=sh:sts=4:sw=4
