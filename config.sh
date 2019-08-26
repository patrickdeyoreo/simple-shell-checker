#!/usr/bin/env bash
#
# Checker configuration file

export SHELL=
export DIFF_OPTS=(
  '-b'
  '--changed-group-format=%<'
  '--unchanged-group-format=%<'
)
