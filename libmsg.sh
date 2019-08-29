#!/usr/bin/env bash
#
# Message formatting library


if (( __libmsg__ ))
then
  [[ $0 != "${BASH_SOURCE[0]}" ]] && return 0 || exit 0
fi
__libmsg__=1


#######################################
# Print a formatted message to standard output (no newline)
# Usage:
#   msg::nonl [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   None
#######################################
msg::nonl()
{
    if (( $# > 0 )); then
        if (( $# > 1 )); then
            printf '%s: ' "${@:1:($# - 1)}"
        fi
        printf '%s' "${!#}"
    fi
}


#######################################
# Print a formatted message to standard output
# Usage:
#   msg::std [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   None
#######################################
msg::std()
{
    msg::nonl "$@"$'\n'
}


#######################################
# Print a formatted message to standard error
# Usage:
#   msg::err [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   None
#######################################
msg::err()
{
    msg::std "$@" 1>&2
}


#######################################
# Print a formatted message to standard error (no newline)
# Usage:
#   msg::err_nonl [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   None
#######################################
msg::err_nonl()
{
    msg::nonl "$@" 1>&2
}


#######################################
# Print a colored message to stdout
# Usage:
#   msg::color COLOR [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   COLOR: color number
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   None
#######################################
msg::color()
{
    if [[ -t 1 ]] && tput setaf &>/dev/null
    then
        msg::std "$(tput setaf "$(($1))")${@:2}$(tput sgr0)"
    else
        msg::std "${@:2}"
    fi
}


#######################################
# Print a colored message to stdout (no newline)
# Usage:
#   msg::color_nonl COLOR [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   COLOR: color number
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   None
#######################################
msg::color_nonl()
{
    if [[ -t 1 ]] && tput setaf &>/dev/null
    then
        msg::nonl "$(tput setaf "$(($1))")${@:2}$(tput sgr0)"
    else
        msg::nonl "${@:2}"
    fi
}


# vi:et:ft=sh:sts=4:sw=4
