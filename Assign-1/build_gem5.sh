#!/bin/zsh
# AMCAS Assignment 1 - gem5 build for this workspace (Python 3.14 / GCC 16).
#
# gem5 v24.0.0.1's bundled pybind11 emits Python 3.14 deprecation warnings
# that -Werror turns fatal. The SConstruct in this repo is already patched
# to drop -Werror (see the PATCH(AMCAS A1) comment at SConstruct:608).
# Build with the course venv:
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
source "$BASE/.venv-gem5/bin/activate"
cd "$BASE/gem5"
python3 "$BASE/.venv-gem5/bin/scons" build/X86/gem5.opt -j14 --ignore-style
echo "gem5 built: $BASE/gem5/build/X86/gem5.opt"
