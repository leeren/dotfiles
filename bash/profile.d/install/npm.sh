#!/bin/bash
#
# Install npm-related tooling.
# TODO: Add nvm: https://hardhat.org/tutorial/setting-up-the-environment.htm

UTIL_DIR="${UTIL_DIR:-${HOME}/profile.d/util}"

function main() {
  brew install npm

  # Installs the solcjs binary, a Solidity compiler.
  npm install -g solc
}

main "$@"
