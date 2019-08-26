#!/usr/bin/env bash
#
# Shell tests function library

# Include guard
if (( __libtest__ ))
then
  [[ $0 != "${BASH_SOURCE}" ]] && return 0 || exit 0
fi
__libtest__=1


if ! source "${BASH_SOURCE%/*}/libmsg.sh"
then
  [[ $0 != "${BASH_SOURCE}" ]] && return 1 || exit 1
fi


#######################################
# Run the full test suite
# Usage:
#   test::all TASK_DIR
# Globals:
#   OUTPUT_DIR
#   SHELL
#   SHELL_PROMPT
# Arguments:
#   TASK_DIR: task directory root
# Return:
#   None
#######################################
test::all()
{
    local output_prefix

    shopt -s nullglob

    for task in "$1"/*
    do
        msg::std "* $(tput bold)Task ${task##*/}$(tput sgr0):"

        for check in "${task}"/*
        do
            output_prefix="${OUTPUT_DIR}/${task##*/}-${check##*/}"

            msg::nonl "    # $(tput sitm)${check##*/}$(tput sgr0):"$'\t'

            if [[ -x ${check} ]]
            then
                test::exec "${check}" "${output_prefix}"
            else
                test::read "${check}" "${output_prefix}"
            fi

            if wait "$!"
            then
                msg::color 2 '[OK]'
            else
                msg::color 1 '[KO]'
                cat
            fi < <(diff "${DIFF_OPTS[@]}" "${output_prefix}"-?-out)
        done
    done

    shopt -u nullglob
}


#######################################
# Run a non-executable test
# Usage:
#   test::read TEST NAME_TEMPLATE
# Globals:
#   SHELL
#   SHELL_REFERENCE
# Arguments:
#   TEST: the test to run
#   NAME_TEMPLATE: output filename prefix
# Return:
#   None
#######################################
test::read()
{
    local i=0
    local shell_esc="${SHELL//\\/\\\\}"
    shell_esc="${shell_esc//&/\\&}"
    shell_esc="${shell_esc//@/\\@}"

    for SHELL in /bin/sh "${SHELL}"
    do
        {   "${SHELL}" <"$1" &
            wait "$!"
            echo "Exit Status: $?"
        }   &> "$2-$((i++))-out"
    done
    sed -i 's@\</bin/sh:@'"${shell_esc}"'@g' "$2"-?-out
}


#######################################
# Run an executable test
# Usage:
#   test::exec TEST NAME_TEMPLATE
# Globals:
#   SHELL
# Arguments:
#   TEST: the test to run
#   NAME_TEMPLATE: output filename prefix
# Return:
#   None
#######################################
test::exec()
{
    local i=0
    local shell_esc="${SHELL//\\/\\\\}"
    shell_esc="${shell_esc//&/\\&}"
    shell_esc="${shell_esc//@/\\@}"

    for SHELL in /bin/sh "${SHELL}"
    do
        {   "$1" "${SHELL}" &
            wait "$!"
            echo "Exit Status: $?"
        }   &> "$2-$((i++))-out"
    done
    sed -i 's@\</bin/sh:@'"${shell_esc}"'@g' "$2"-?-out
}


# vi:et:ft=sh:sts=4:sw=4
