#!/usr/bin/env bash
#
# Shell tests function library


if (( __libtest__ ))
then
    [[ $0 != "${BASH_SOURCE}" ]] && return 0 || exit 0
fi
__libtest__=1


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
    local task check prefix

    shopt -s nullglob

    for task in "$1"/*
    do
        msg::std "$(tput smul)$(tput bold)> Task ${task##*/}$(tput sgr0):"

        for check in "${task}"/*
        do
            prefix="${OUTPUT_DIR}/${task##*/}-${check##*/}"

            if [[ -x ${check} ]]
            then
                if wait "$!"
                then
                    msg::nonl '['
                    msg::color_nonl 2 'OK'
                    msg::nonl ']'
                    msg::std " ${check##*/}"
                else
                    msg::nonl '['
                    msg::color_nonl 1 'KO'
                    msg::nonl ']'
                    msg::std " ${check##*/}"
                    tput dim
                    sed 's/^/     /g'
                    tput sgr0
                fi < <("${check}")
            else
                test::read "${check}" "${prefix}"
                if wait "$!"
                then
                    msg::nonl '['
                    msg::color_nonl 2 'OK'
                    msg::nonl ']'
                    msg::std " ${check##*/}"
                else
                    msg::nonl '['
                    msg::color_nonl 1 'KO'
                    msg::nonl ']'
                    msg::std " ${check##*/}"
                    tput dim
                    sed 's/^/     /g'
                    tput sgr0
                fi < <(diff "${DIFF_OPTS[@]}" "${prefix}"-?-out)
            fi
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
#   NAME_TEMPLATE: output filename out_prefix
# Return:
#   None
#######################################
test::read()
{
    local i=0
    local shell_esc="${SHELL//\\/\\\\}"
    shell_esc="${shell_esc//&/\\&}"

    for SHELL in /bin/sh "${SHELL}"
    do
        {   "${SHELL}" <"$1" &
            wait "$!"
            echo "Exit Status: $?"
        }   &> "$2-$((i++))-out"
    done
    sed -i 's@/bin/sh@'"${shell_esc//@/\\@}"'@g' "$2"-?-out
}


#######################################
# Run an executable test
# Usage:
#   test::exec TEST NAME_TEMPLATE
# Globals:
#   SHELL
# Arguments:
#   TEST: the test to run
#   NAME_TEMPLATE: output filename out_prefix
# Return:
#   None
#######################################
#test::exec()
#{
#}


# vi:et:ft=sh:sts=4:sw=4
