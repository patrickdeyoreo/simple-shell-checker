#!/usr/bin/env bash

set -o errexit -o pipefail

CDPATH= cd -- "$(CDPATH= cd -- "${BASH_SOURCE%/*}" && pwd -P)"

exec 1> AUTHORS

cat << 'EOH'
# This file lists all individuals having contributed content to the repository.

EOH

git log --format='%aN <%aE>' | LC_ALL=C.UTF-8 sort -uf
