#!/bin/bash
#
# Installation entry point for all shell packages.

UTIL_DIR="${UTIL_DIR:-${HOME}/profile.d/util}"
INSTALL_DIR="${INSTALL_DIR:-${HOME}/profile.d/install}"
GCLOUD_SDK_DIR="${GCLOUD_SDK_DIR:-/usr/local/google-cloud-sdk}"

# shellcheck source=./profile.d/util/log.sh
. "${UTIL_DIR}/log.sh"  || { echo ". ${UTIL_DIR}/log.sh failed!" >&2; exit 1; }

if [[ ! -d "${INSTALL_DIR}" ]]; then
  util::error "Unable to locate installation directory ${INSTALL_DIR}!"
fi

# Ensure all necessary packages are installed.
for i in ~/profile.d/install/*.sh; do
  if [[ -r "${i}" ]] && bash "${i}" ; then
    util::info "Installation of ${i} was successful!"
  else
    util::error "Installation of ${i} was unsuccessful!"
  fi
done
