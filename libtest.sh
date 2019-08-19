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
    for task in "$1"/*; do
        msg::std "> Task ${task##*/}:"
        for check in "${task}"/*; do
            msg::nonl "    # ${check##*/}: "
            if [[ -x ${check} ]]; then
                test::exec "${check}" "${task##*/}-${check##*/}"
            else
                test::read "${check}" "${task##*/}-${check##*/}"
            fi
            if diff -q "${task##*/}-${check##*/}"-*-stdout 1>/dev/null; then
                msg::color 2 '[OK]'
            else
                msg::color 1 '[KO]'
            fi
        done
    done
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
    for SHELL in /bin/sh "${SHELL}"; do
        ("${SHELL}" 0< "$1"; echo "$?") \
            1> "$2-${SHELL##*/}-stdout" \
            2> "$2-${SHELL##*/}-stderr"
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
    for SHELL in /bin/sh "${SHELL}"; do
        ("${check}"; echo "$?") \
            1>"$2-${SHELL##*/}-stdout" \
            2>"$2-${SHELL##*/}-stderr"
    done </dev/null
}


# vi:et:ft=sh:sts=4:sw=4
