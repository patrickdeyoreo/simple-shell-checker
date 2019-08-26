#!/usr/bin/env bash
#
# Manipulate variables by reference

# Include guard
if (( __libref__ ))
then
  [[ $0 != "${BASH_SOURCE}" ]] && return 0 || exit 0
fi
__libref__=1


if ! source "${BASH_SOURCE%/*}/libmsg.sh"
then
  [[ $0 != "${BASH_SOURCE}" ]] && return 1 || exit 1
fi


######################################
# Assign a value to a variable by reference
# Usage:
#   ref::assign NAME VALUE
# Globals:
#   None
# Arguments:
#   NAME: variable name
#   VALUE: value to assign
# Return:
#   2 if given the wrong number of arguments,
#   1 if given an invalid identifier or a bad array subscript,
#   0 upon successful assignment,
#   otherwise non-zero
######################################
ref::assign()
{
    if (( $# != 2 )); then
        msg::error 'usage' "${FUNCNAME} name value"
        return 2
    fi
    if [[ ! $1 =~ ^([[:alpha:]_][[:alnum:]_]*)(\[(.*)])?$ ]]; then
        msg::error "${FUNCNAME}" "$1" 'not a valid identifier' 
        return 1
    fi
    if [[ -z ${BASH_REMATCH[2]} ]]; then
        eval "$1"'=$2'
    elif [[ ${!BASH_REMATCH[1]@a} == *A* ]]; then
        eval "${BASH_REMATCH[1]}[${BASH_REMATCH[3]@Q}]"'=$2'
    elif (( $((BASH_REMATCH[3])), 1 )) 2>/dev/null; then
        eval "${BASH_REMATCH[1]}[$((BASH_REMATCH[3]))]"'=$2'
    else
        msg::error "${FUNCNAME}" "${BASH_REMATCH[0]}" 'bad array subscript'
        return 1
    fi
}


######################################
# Assign options to an associative array by reference
# Usage:
#   ref::getopts NAME OPTSTRING [ARG ...]
# Globals:
#   OPTIND
# Arguments:
#   NAME: an initialized associative array to store options and arguments
#   OPTSTRING: the optstring to pass to getopts
#   ARG: argument(s) to parse
# Return:
#   2 if an invalid option is found or an option is missing an argument,
#   1 if name is an invalid identifier or an array with a bad subscript,
#   0 upon success,
#   otherwise non-zero
######################################
ref::getopts()
{
    local OPTARG
    local option

    OPTIND=1

    while getopts ":$2" option "${@:3}"; do
        case "${option}" in
            : ) msg::error "${0##*/}" "${OPTARG}" 'option requires an argument'
                return 2
                ;;
            \?) msg::error "${0##*/}" "${OPTARG}" 'invalid option'
                return 2
                ;;
            * ) ref::assign "$1[${option}]" "${OPTARG}"
                ;;
        esac
    done
}


# vi:et:ft=sh:sts=4:sw=4
