#!/usr/bin/env bash
#
# Message formatting library

# Include guard
if (( __libmsg__ ))
then
  [[ $0 != "${BASH_SOURCE}" ]] && return 0 || exit 0
fi
__libmsg__=1


#######################################
# Print a formatted message (no newline)
# Usage:
#   msg::nonl [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   exit status of the previous command
#######################################
msg::nonl()
{
    local last_exit_status="$?"

    if (( $# > 0 )); then
        if (( $# > 1 )); then
            printf '%s: ' "${@:1:($# - 1)}"
        fi
        printf '%s' "${!#}"
    fi
    return "${last_exit_status}"
}


#######################################
# Print a formatted message to stdout
# Usage:
#   msg::std [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   exit status of the previous command
#######################################
msg::std()
{
    msg::nonl "$@"$'\n'
}


#######################################
# Print a formatted message to stderr (nonl)
# Usage:
#   msg::error [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   exit status of the previous command
#######################################
msg::error()
{
    msg::std "$@" 1>&2
}


#######################################
# Print a formatted message to stderr
# Usage:
#   msg::error_nonl [CONTEXT ...] MESSAGE
# Globals:
#   None
# Arguments:
#   CONTEXT: program(s), function(s), or value(s) to prepend
#   MESSAGE: message to print
# Return:
#   exit status of the previous command
#######################################
msg::error_nonl()
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
#   exit status of the previous command
#######################################
msg::color()
{
    if [[ -t 1 ]] && tput setaf &>/dev/null; then
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
#   exit status of the previous command
#######################################
msg::color_nonl()
{
    if [[ -t 1 ]] && tput setaf &>/dev/null; then
        msg::nonl "$(tput setaf "$(($1))")${@:2}$(tput sgr0)"
    else
        msg::nonl "${@:2}"
    fi
}


# vi:et:ft=sh:sts=4:sw=4
