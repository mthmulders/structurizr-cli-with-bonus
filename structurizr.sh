#!/usr/bin/env bash
set -euo pipefail

install_dir=$( dirname -- "$( readlink -f -- "$0"; )"; )
java -jar $install_dir/structurizr.war "$@"