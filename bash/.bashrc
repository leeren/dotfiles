#!/bin/bash
#
# Main entry point to sourcing all configuration files.

# If shell options indicate use of non-interactive mode, do nothing.
if [[ ! $- =~ 'i' ]]; then
	return
fi

# Source $HOME/.profile
if [[ -f "$HOME/.profile" ]]; then
  . "$HOME/.profile"
fi

# Source $HOME/.bash_profile
if [[ -f "$HOME/.bash_profile" ]]; then
  . "$HOME/.bash_profile"
fi

# Source all the bash aliases.
if [[ -f "$HOME/.bash_aliases" ]]; then
  . "$HOME/.bash_aliases"
fi

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
