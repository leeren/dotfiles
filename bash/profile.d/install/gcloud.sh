#!/bin/bash
#
# Install gcloud SDK and related components.

UTIL_DIR="${UTIL_DIR:-${HOME}/profile.d/util}"
GCLOUD_CONFIG_PATH="${HOME}/profile.d/config/gcloud.sh"
GCLOUD_SDK_DIR="${GCLOUD_SDK_DIR:-${HOME}/google-cloud-sdk}"
SDK="google-cloud-sdk-290.0.1-darwin-x86_64.tar.gz"

# shellcheck source=./profile.d/util/log.sh
. "${UTIL_DIR}/log.sh"  || { echo ". ${UTIL_DIR}/log.sh failed!" >&2; exit 1; }
# shellcheck source=./profile.d/util/log.sh
. "${UTIL_DIR}/util.sh"  || util::exit ". ${UTIL_DIR}/util.sh failed!"

function help() {
  cat <<EOF
usage: ${0} [-h] [-f]

Installs the gcloud SDK under the directory given by \$GCLOUD_SDK_DIR, which is
currently set to ${GCLOUD_SDK_DIR}.

  -h          Print out the help message.
  -f          Force a reinstall.
EOF
  exit 0
}

function main() {

  local force=0 help=0
  while getopts "f" opt; do
    case "${opt}" in
      f) force=1 ;;
      *) help ;;
    esac
  done
  shift $((OPTIND-1))
  
  # Check whether gcloud binary already exists and uninstall if passing `-f`.
  if util::binary_exists gcloud; then
    install_dir="$(gcloud info --format='value(installation.sdk_root)')"
    usr_config="$(gcloud info --format='value(config.paths.global_config_dir)')"
    util::info "gcloud already exists with SDK installed in ${install_dir}."
    if (( force == 0 )); then
      if [[ "${install_dir}" != "${GCLOUD_SDK_DIR}" ]]; then
        util::warning "Current install dir ${install_dir} != \$GCLOUD_SDK_DIR!"
      fi
      util::info "To force a reinstall of gcloud, run ${0} -f."
    else
      util::info "Force option -f provided, gcloud will be reinstalled."
      util::info "Deleting current cloud SDK install dir ${install_dir}..."
      rm -rf "${install_dir}"
      util::info "Deleting current user config directory ${usr_config}..."
      rm -rf "${usr_config}"
      util::warn "Review .boto file to remove additional unwanted gcloud configs."
    fi
  fi

  # Check if $GCLOUD_SDK_DIR already exists and delete it if `-f` is passed in.
  if [[ -d "${GCLOUD_SDK_DIR}" ]] && (( force == 1 )); then
      util::info "Removing existing \$GCLOUD_SDK_DIR since '-f' passed in..."
      rm -rf "${GCLOUD_SDK_DIR}"
      util::info "Existing directory \$GCLOUD_SDK_DIR deleted!"
  fi

  # Start the installation process.
  if [[ ! -d "${GCLOUD_SDK_DIR}" ]]; then
    util::info "Creating SDK directory in ${GCLOUD_SDK_DIR}..."
    if ! mkdir -p "${GCLOUD_SDK_DIR}"; then
      util::exit "Creation of ${GCLOUD_SDK_DIR} failed!"
    fi
    util::info "Directory ${GCLOUD_SDK_DIR} created!"
  fi

  if [[ ! -f "${GCLOUD_SDK_DIR}/install.sh" ]]; then
    util::info "Extracting gcloud SDK to ${GCLOUD_SDK_DIR}..."
    if [[ "${OSTYPE}" == "darwin"* ]]; then
      curl --progress-bar -SL \
        "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${SDK}" | \
        tar -x - -C "${GCLOUD_SDK_DIR}" --strip-components 1
    elif [[ "${OSTYPE}" == "linux-gnu"* ]]; then
      curl --progress-bar -SL \
        "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${SDK}" | \
        tar -zxf - -C "${GCLOUD_SDK_DIR}" --strip-components 1
    else
      util::error "OS platform ${OSTYPE} not supported for gcloud installation."
    fi

    if (( PIPESTATUS[0] != 0 || PIPESTATUS[1] != 0 )); then
      util::exit "gcloud SDK extraction to ${GCLOUD_SDK_DIR} failed!"
    fi
    util::info "gcloud SDK successfully extracted to ${GCLOUD_SDK_DIR}!"

    util::info "Installing gcloud SDK..."
    if ! "${GCLOUD_SDK_DIR}/install.sh" \
      --quiet --bash-completion false \
      --path-update false \
      --additional-components alpha beta kubectl; then
      util::exit "gcloud SDK failed to install!"
    fi
    util::info "gcloud SDK installation successful!"
  else
    util::info "Install script already exists, extraction skipped!"
    util::info "To force a fresh install extraction, run ${0} -f."
  fi

  local gcloud_bin="${GCLOUD_SDK_DIR}/bin/gcloud"
  util::info "Updating gcloud components to latest version..."
  if ! "${gcloud_bin}" components update -q &>/dev/null; then
    util::exit "gcloud SDK update failed!"
  fi
  util::info "Update successful!"

  if [[ -z "$("${gcloud_bin}" auth list --format="value(ACCOUNT)")" ]]; then
    util::warn "gcloud account has no valid credentials, obtaining new creds..."
    if ! "${gcloud_bin}" auth login; then
      util::exit "gcloud authentication failed!"
    fi
  fi

  util::info "Installation of gcloud complete!"
}

main "$@"
