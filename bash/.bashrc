#!/bin/bash
#
# Main entry point to sourcing all configuration files.

# Define all installation and configuration environment variables.
export CONFIG_DIR="${HOME}/profile.d/config"
export INSTALL_DIR="${HOME}/profile.d/install"
export UTIL_DIR="${HOME}/profile.d/util"
export GCLOUD_SDK_DIR="${HOME}/google-cloud-sdk"
export GO_PATH=~/go
export PATH=$PATH:/$GO_PATH/bin
export PATH="/Users/leeren/.local/bin:$PATH"

alias gccl="gcloud config configurations list"
alias aacl="aws configure list-profiles"
function switch_gcp_profile() {
    export GCP_PROFILE="$1"
}
function switch_aws_profile() {
    export AWS_PROFILE="$1"
}
alias aa=switch_aws_profile


alias nvim='nvim -c "let g:tty='\''$(tty)'\''"'

function get_date () {
  d=`date -j -f date -j -f "%Y/%m/%d %T" "2022/$1/$2 $3:$4:00" +"%s"`
  echo "<t:$d>"
}

# shellcheck source=./profile.d/util/log.sh
. "${UTIL_DIR}/log.sh"  || { echo ". ${UTIL_DIR}/log.sh failed!" >&2; exit 1; }

# Source all configuration files.
# if [[ -d "${HOME}/profile.d/config" ]]; then
#   for c in ~/profile.d/config/*.sh; do
#     if [ ! -r "${c}" ]; then
#       util::warning "Unable to read configuration file $c!"
#       continue
#     fi
#     # shellcheck source=/dev/null
#     if ! . "${c}"; then
#       util::warning "Unable to source configuration file $c!"
#       continue
#     fi
#   done
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

export PATH="$PATH:/Users/leeren/.foundry/bin"
export PATH="$PATH:/Users/leeren/google-cloud-sdk/bin"
# export PATH="$PATH:/users/leeren/google-cloud-sdk/bin"

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
KUBE_PS1_SYMBOL_ENABLE=false
PS1='$(kube_ps1)[${AWS_PROFILE}]\w: '
