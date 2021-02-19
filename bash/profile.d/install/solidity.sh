#!/bin/bash
#
# Install Solidity tooling

UTIL_DIR="${UTIL_DIR:-${HOME}/profile.d/util}"
SOL_DIR="$HOME/solidity"

function main() {
  git clone --recursive https://github.com/ethereum/solidity.git $SOL_DIR
  bash $SOL_DIR/scripts/install_deps.sh
  bash $SOL_DIR/scripts/build.sh
}

main "$@"
