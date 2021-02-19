#!/bin/bash
#
# Main entry point to sourcing all configuration files.

# Define all installation and configuration environment variables.
export CONFIG_DIR="${HOME}/profile.d/config"
export INSTALL_DIR="${HOME}/profile.d/install"
export UTIL_DIR="${HOME}/profile.d/util"
export GCLOUD_SDK_DIR="${HOME}/google-cloud-sdk"

# shellcheck source=./profile.d/util/log.sh
. "${UTIL_DIR}/log.sh"  || { echo ". ${UTIL_DIR}/log.sh failed!" >&2; exit 1; }

# Source all configuration files.
if [[ -d "${HOME}/profile.d/config" ]]; then
  for c in ~/profile.d/config/*.sh; do
    if [ ! -r "${c}" ]; then
      util::warning "Unable to read configuration file $c!"
      continue
    fi
    # shellcheck source=/dev/null
    if ! . "${c}"; then
      util::warning "Unable to source configuration file $c!"
      continue
    fi
  done
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
