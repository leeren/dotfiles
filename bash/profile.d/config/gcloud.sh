#!/bin/bash
#
# The below scripts ease use of working with GCP.

UTIL_DIR="${UTIL_DIR:-${HOME}/profile.d/util}"

# shellcheck source=./profile.d/util/log.sh
. "${UTIL_DIR}/log.sh" || { echo ". ${UTIL_DIR}/log.sh failed!" >&2; exit 1; }
# shellcheck source=./profile.d/util/util.sh
. "${UTIL_DIR}/util.sh" || { echo ". ${UTIL_DIR}/util.sh failed!" >&2; exit 1; }

GCLOUD_SDK_DIR="${GCLOUD_SDK_DIR:-${HOME}/google-cloud-sdk}"

if [[ ! -d "${GCLOUD_SDK_DIR}" ]] ; then
  util::error "gcloud SDK not found. Install via \`bash install/gcloud.sh\`."
  return $?
fi

. "${GCLOUD_SDK_DIR}/path.bash.inc"
. "${GCLOUD_SDK_DIR}/completion.bash.inc"

export RESOURCE_MANAGER_API='https://cloudresourcemanager.googleapis.com'
export ORG='leerenchang.com'
if ! org_id="$(gcloud organizations list \
  --format "value(ID)" \
  --filter "display_name:${ORG}"
)"; then
 util::error "Error retrieving organization ID!"
fi
export ORG_ID=${org_id}

# Useful aliases for interacting with GCP endpoints and gcloud.
alias gcurl='curl -H "Authorization: Bearer $(gcloud auth print-access-token)"'
alias gpost='gcurl -XPOST -H "Content-Type: application/json"'

function test_org_permissions() {
  gpost -sS \
    "${RESOURCE_MANAGER_API}/v1/organizations/${ORG_ID}:testIamPermissions" \
    -d @- <<EOF
{
  "permissions": [
    "$(join_args '","' "$@")"
  ] 
}
EOF
}

function get_org_iam_policy() {
  gpost -sS "${RESOURCE_MANAGER_API}/v1/organizations/${ORG_ID}:getIamPolicy"
}

