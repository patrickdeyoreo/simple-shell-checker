#!/usr/bin/env bash
#
# Run a test suite for the Holberton shell project


set -o errexit

USAGE="${BASH_SOURCE##*/} [-r REPO] [SHELL]"

SOURCE_DIR="$(CDPATH='' cd -- "${BASH_SOURCE%/*}" && pwd -P)"

OUTPUT_DIR="$(mktemp -d --tmpdir -- "${BASH_SOURCE##*/}-XXX")"

trap -- 'rm -rf "${OUTPUT_DIR}"' EXIT


source -- "${SOURCE_DIR}/config.sh"

source -- "${SOURCE_DIR}/libmsg.sh"

source -- "${SOURCE_DIR}/libtest.sh"


OPTIND=1

while getopts ":r:h" option; do
    case "${option}" in
        r ) REPO="${OPTARG}"
            ;;
        h ) msg::std "${0##*/}" 'usage' "${USAGE}"
            exit 2
            ;;
        : ) msg::error "${0##*/}" "${OPTARG}" 'option requires an argument'
            exit 2
            ;;
        \?) msg::error "${0##*/}" "${OPTARG}" 'invalid option'
            exit 2
            ;;
    esac
done

shift "$((OPTIND - 1))"

if (( $# ))
then
    SHELL="$1"
fi

set +o errexit


if (( $# > 1 ))
then
    msg::error "${0##*/}" 'too many arguments'
    exit 1
fi

if [[ -n ${REPO} && ! -d ${REPO} ]]
then
    msg::error "${0##*/}" 'REPO' "${REPO}" 'No such directory'
    exit 1
fi

if ! [[ -n ${SHELL} ]]
then
    msg::error "${0##*/}" 'SHELL' "supply as argument or specify in 'config.sh'"
    exit 1
fi

if ! [[ -e ${SHELL} ]]
then
    msg::error "${0##*/}" "${SHELL}" 'No such file or directory'
    exit 1
fi
if ! [[ -r ${SHELL} && -x ${SHELL} ]]
then
    msg::error "${0##*/}" "${SHELL}" 'Permission denied'
    exit 1
fi


SHELL="${SHELL}" REPO="${REPO}" test::all "${SOURCE_DIR}/tasks"


# vi:et:ft=sh:sts=4:sw=4
