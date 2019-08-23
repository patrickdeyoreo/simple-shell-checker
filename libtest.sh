#!/usr/bin/env bash
#
# Test function library


#######################################
# Run the full test suite
# Usage:
#   test::all TASK_DIR
# Globals:
#   SHELL
# Arguments:
#   TASK_DIR: task directory root
# Return:
#   None
#######################################
test::all()
{
    shopt -s nullglob

    for task in "$1"/*
    do
        msg::std "* Task ${task##*/}:"

        for check in "${task}"/*
        do
            msg::nonl "  ${check##*/}: "

            if [[ -x ${check} ]]
            then
                test::exec "${check}" "${task##*/}-${check##*/}"
            else
                test::read "${check}" "${task##*/}-${check##*/}"
            fi

            if wait "$!"
            then
                msg::color 2 '[OK]'
            else
                msg::color 1 '[KO]'
                cat
            fi < <(diff -bB -y -W "$(( "$(tput cols)" / 2 ))" "${task##*/}-${check##*/}"-*-stdout)
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
# Arguments:
#   TEST: the test to run
#   NAME_TEMPLATE: output filename prefix
# Return:
#   None
#######################################
test::read()
{
    for SHELL in /bin/sh "${SHELL}"
    do
        {   "${SHELL}" <"$1" &
            wait "$!"
            echo "EXIT STATUS: $?"
        }   1> >(sed 's:/bin/sh:'"${SHELL//&/\\&}"':g' >"$2-${SHELL##*/}-stdout") \
            2> >(sed 's:/bin/sh:'"${SHELL//&/\\&}"':g' >"$2-${SHELL##*/}-stderr")
    done
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
    for SHELL in /bin/sh "${SHELL}"
    do
        {   "$1" "${SHELL}" &
            wait "$!"
            echo "EXIT STATUS: $?"
        }   1> >(sed 's:/bin/sh:'"${SHELL//&/\\&}"':g' >"$2-${SHELL##*/}-stdout") \
            2> >(sed 's:/bin/sh:'"${SHELL//&/\\&}"':g' >"$2-${SHELL##*/}-stderr")
    done </dev/null
}


# vi:et:ft=sh:sts=4:sw=4
