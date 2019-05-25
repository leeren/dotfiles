PATH=$PATH:~/go/bin
# Configure oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# General aliases
alias vi='nvim -c "let g:tty='\''$(tty)'\''"'
alias a='awk "{print \$1}"'
alias z='awk "{print \$NF}"'

function n () {
  sed -n $1p
}

function urldecode() {
  python3 -c 'from urllib.parse import unquote_plus as up; print(up("'"$1"'"))'
}
function urlencode() {
  python3 -c 'from urllib.parse import urlencode; print(urlencode('"$1"'))'
}
function urlencode() {
  python3 -c 'from urllib.parse import quote_plus as qp; print(qp("'"$1"'"))'
}
export CDPATH=.:~:~/workspace
# Ctrl-w is bound in stty to werase, so unbind it and rebind
stty werase undef

# Disable START and STOP signals, in this case stop Ctrl-S -> XOFF Mapping
stty -ixon

# GCLOUD
alias glp='gcloud projects list'
alias gcp='gcloud config list --format "value(core.project)"'
function gsp () {
  gcloud config set project $1
}
alias g='gcloud'
alias gc='gcloud compute'
alias gcc='gcloud container clusters list'
function gfc () {
  if [[ $1 =~ [0-9] ]]
  then
    gcloud container clusters get-credentials $(gcc --format "value(NAME)" | n $1) --zone $(gcc --format "value(ZONE)" | n $1)
  else
    gcloud container clusters get-credentials $1 --zone $(gcc --filter="name:$1" --format="value(ZONE)")
  fi
}

# KUBERNETES ALIASES
alias k='kubectl'
alias kc='kubectl config'
alias kcc='kubectl config current-context'
function ksc () {
  if [[ $1 =~ [0-9] ]]
  then 
    kubectl config use-context $(klc | n $1)
  else
    kubectl config use-context $1
  fi
}
function kl () {
  kubectl config view -o jsonpath="{.$1[*].name}" | xargs -n1
}
alias nodeips='kubectl get nodes -o jsonpath='"'"'{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'"'"
function ku () {
  TYPE=${1:-contexts}
  WHAT=${2:-1}
  if [[ $2 =~ ^[0-9]$ ]]
  then
    kubectl config unset "$TYPE.$(kl $TYPE | n $WHAT)"
  else
    kubectl config unset "$TYPE.$WHAT"
  fi
}
alias klc='kl contexts'
alias klu='kl users'
alias klcl='kl clusters'
function kuc () {
  ku contexts $1
}
function kuu () {
  ku users $1
}
function kucl () {
  ku clusters $1
}

alias kg='kubectl get'
alias kgn='kubectl get nodes -o wide --all-namespaces'
alias kgs='kubectl get services --show-labels --no-headers'
alias kgpo='kubectl get pods --no-headers -o wide'
function kgsy () {
  if [[ $1 =~ [0-9] ]]
  then 
    kubectl get services $(kgs | n $1 | a) -o yaml
  else
    kubectl get services $1 -o yaml
  fi
}
function kgspo () {
  if [[ $1 =~ [0-9] ]]
  then 
    kgpo --selector $(kgs | n $1 | awk "{print \$NF}") | ( [[ "$2" ]] && n $2 | awk "{print \$2}" || cat)
  else
    kgpo --all-namespaces --selector $(kgs --no-headers --all-namespaces --field-selector metadata.name=$1 | z) | ( [[ "$2" ]] && n $2 | awk "{print \$2}" || cat)
  fi
}
function kgspoy () {
  if [[ $2 =~ [0-9] ]]
  then 
    kgpo --all-namespaces --field-selector metadata.name=$(kgspo $1 $2) -o yaml | yq '.'
    return 1
  fi
  if [[ $1 =~ [0-9] ]]
  then 
    kgpo --selector $(kgs | n $1 | z) -o yaml | yq '.'
  else
    kgpo --all-namespaces --selector $(kgs --no-headers --all-namespaces --field-selector metadata.name=$1 | z) -o yaml | yq '.'
  fi
}
function kgpoc () {
  kg pods $1 -n ${2:-default}  -o jsonpath="{.spec.containers[*].name}" | xargs -n1 | ( [[ "$3" ]] & n $3 || cat )
}
function kgsc () {
  NUM=${3:-1}
  kgpoc $(kgspo $1 | n $NUM | awk '{print $2}' ) $2
}
alias kgposl='kubectl get pods --show-labels'
alias ka='kubectl apply --recursive -f'
function kat() {
  kubectl exec -it $(kgspo $1 ${4:-1}) -n ${2:-default} -c $(kgsc $1 ${2:-default} ${4:-1} ${5:-1}) ${3:-bash}
}
function kpf() {
  kubectl port-forward $(kgspo $1 ${4:-1}) $2:$3 &
}

alias tsdev='NODE_ENV=dev NODE_PATH=. nodemon -e ts -w ./src -x "npm run build && node ./dist"'

function getRoles () {
    local kind="${1}"
    local name="${2}"
    local namespace="${3:-}"

    kubectl get clusterrolebinding -o json | jq -r "
      .items[]
      | 
      select(
        .subjects[]?
        | 
        select(
            .kind == \"${kind}\" 
            and
            .name == \"${name}\"
            and
            (if .namespace then .namespace else \"\" end) == \"${namespace}\"
        )
      )
      |
      (.roleRef.kind + \"/\" + .roleRef.name)
    "
}


function perm () {
        curl -s https://cloud.google.com/kubernetes-engine/docs/reference/api-permissions | grep $1 | grep -oP '(?<=<code>).*?(?=</code>)'
}
alias -g gkeapi="-v=6 2>&1 | grep --color=none -oP '[A-Za-z]+ http[^\s]*' | sed -e 's/^\(.* \).*\(\/apis.*\)/\1\2/' "
alias -g an="--all-namespaces"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google/home/leeren/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/google/home/leeren/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google/home/leeren/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/google/home/leeren/google-cloud-sdk/completion.zsh.inc'; fi
source /etc/bash_completion.d/g4d

alias gcurl='curl -H "Authorization: Bearer $(gcloud auth print-access-token)"'

[ -f "$HOME/.zshrc.corp" ] && source $HOME/.zshrc.corp

function repl () {
  node -i -e "$(< $1.js)"
}

function def () {
  declare -f $1
}
function get_alias() {
  printf '%s\n' $aliases[$1]
}
