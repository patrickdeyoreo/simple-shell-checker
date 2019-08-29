#!/usr/bin/env bash
#
# Run a test suite for the Holberton shell project


set -o errexit

USAGE="${BASH_SOURCE##*/} [SHELL]"

SOURCE_DIR="$(CDPATH='' cd -- "${BASH_SOURCE%/*}" && pwd -P)"

OUTPUT_DIR="$(mktemp -d --tmpdir -- "${BASH_SOURCE##*/}-XXX")"

trap -- 'rm -rf "${OUTPUT_DIR}"' EXIT

source -- "${SOURCE_DIR}/config.sh"

source -- "${SOURCE_DIR}/libmsg.sh"

source -- "${SOURCE_DIR}/libtest.sh"

OPTIND=1

while getopts ":h" opt
do
    case "${opt}" in
        h ) msg::std "${0##*/}" 'usage' "${USAGE}"
            ;;&
        \?) msg::err "${0##*/}" "-${OPTARG}" 'invalid option'
            ;;&
        * ) exit 2
    esac
done

shift "$((OPTIND - 1))"

if (( $# ))
then
    SHELL="$1"
    shift
fi

set +o errexit


if (( $# ))
then
    msg::err "${0##*/}" 'too many arguments'
    exit 1
fi

if [[ -z ${SHELL} ]]
then
    msg::err "${0##*/}" 'SHELL' "supply as an argument or define in config.sh"
    exit 1
fi

if ! [[ -e ${SHELL} ]]
then
    msg::err "${0##*/}" "${SHELL}" 'No such file or directory'
    exit 1
fi

if ! [[ -r ${SHELL} && -x ${SHELL} ]]
then
    msg::err "${0##*/}" "${SHELL}" 'Permission denied'
    exit 1
fi


test::all "${SOURCE_DIR}/tasks"


# vi:et:ft=sh:sts=4:sw=4
