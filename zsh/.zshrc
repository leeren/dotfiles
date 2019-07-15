PATH=$PATH:~/go/bin
PATH=$PATH:$HOME/boost_1_66_0
path=$PATH:~/wrk
PATH=$PATH:~/
PATH=$PATH:$HOME/.local/lib/python2.7/site-packages
# Configure oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# General aliases
alias vi='nvim -c "let g:tty='\''$(tty)'\''"'
alias a='awk "{print \$1}"'
alias z='awk "{print \$NF}"'
function c () {
  awk "{print \$$1}"
}

function krep () {
  awk "NR==1 || /$1/"
}
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
alias g='gcloud'
alias gc='gcloud compute'
alias gcc='gcloud container clusters list'
alias glp='gcloud projects list'
alias gcp='gcloud config list --format "value(core.project)"'
function getzone() {
  gcloud compute instances list --filter="name:$1" --format="value(zone)"
}
function gsz() {
  gcloud config set compute/zone $1
}
function gsp () {
  gcloud config set project $1
}
function gfc () {
  if [[ $1 =~ [0-9] ]]
  then
    gcloud container clusters get-credentials $(gcc --format "value(NAME)" | n $1) --zone $(gcc --format "value(ZONE)" | n $1)
  else
    gcloud container clusters get-credentials $1 --zone $(gcc --filter="name:$1" --format="value(ZONE)")
  fi
}

function kl () {
  kubectl config view -o jsonpath="{.$1[*].name}" | xargs -n1
}
alias klc='kl contexts'
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
alias nodeips='kubectl get nodes -o=custom-columns='"'"'NAME:.metadata.name,INTERNAL IP:.status.addresses[?(@.type=="InternalIP")].address,EXTERNAL IP:.status.addresses[?(@.type=="ExternalIP")].address'"'"
alias kg='kubectl get'
alias kgn='kubectl get nodes -o wide --all-namespaces'
function kgpo() {
  if [ -z $1 ] || [[ $1 == -* ]]
  then
    kubectl get pods --all-namespaces -o wide ${*:1}
    return 1
  fi
  if [[ $1 =~ [0-9] ]]
  then
    local pod=$(kubectl get pods --all-namespaces --no-headers -o=custom-columns=":metadata.name" | n $1)
  fi
  kubectl get pods --all-namespaces --field-selector metadata.name=${pod:-${1}} -o wide ${*:2}
}
function kgst() {
  if [ -z $1 ] || [[ $1 == -* ]]
  then
    kubectl get statefulsets --all-namespaces -o wide ${*:1}
    return 1
  fi
  if [[ $1 =~ [0-9] ]]
  then
    local statefulset=$(kubectl get statefulsets --all-namespaces --no-headers -o=custom-columns=":metadata.name" | n $1)
  fi
  kubectl get statefulsets --all-namespaces --field-selector metadata.name=${statefulset:-${1}} -o wide ${*:2}
}
function kgd() {
  if [ -z $1 ] || [[ $1 == -* ]]
  then
    kubectl get deployments --all-namespaces -o wide -o=custom-columns="NAME:.metadata.name,DESIRED:.spec.replicas,CURRENT:.status.replicas,UP-TO-DATE:.status.updatedReplicas,AVAIL:.status.availableReplicas,CONTAINERS:.spec.template.spec.containers[*].name,IMAGE:.spec.template.spec.containers[*].image" ${*:1}
    return 1
  fi
  if [[ $1 =~ [0-9] ]]
  then
    local deployment=$(kubectl get deployments --all-namespaces --no-headers -o=custom-columns=":metadata.name" | n $1)
  fi
  kubectl get deployments --all-namespaces --field-selector metadata.name=${deployment:-${1}} -o wide ${*:2}
}
function kgs() {
  if [ -z $1 ] || [[ $1 == -* ]]
  then
    kubectl get services --all-namespaces -o wide ${*:1}
    return 1
  fi
  if [[ $1 =~ [0-9] ]]
  then
    local service=$(kubectl get services --all-namespaces --no-headers -o=custom-columns=":metadata.name" | n $1)
  fi
  kubectl get services --all-namespaces --field-selector metadata.name=${service:-${1}} -o wide ${*:2}
}
function kgspo () {
  if [[ $1 =~ [0-9] ]]
  then
    local service=$(kgs --no-headers -o=custom-columns=":metadata.name" | n $1)
  fi
  local selector=$(kgs ${service:-${1}} -o=custom-columns=":{.spec.selector}" --no-headers | sed 's/map\[\([^] ]*\).*/\1/' | tr : =)
  if [[ $2 =~ [0-9] ]]
  then
    local pod=$(kgpo --selector "$selector" -o=custom-columns=":metadata.name" --no-headers | n $2)
    kgpo --field-selector metadata.name="$pod" ${*:3}
  else
    kgpo --selector "$selector" ${*:2}
  fi
}
function kgspoc () {
  kgspo $1 -o=custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,CONTAINERS:.spec.containers[*].name,POD IP:.status.podIP,NODE IP:.status.hostIP" ${*:2}
}
function kat() {
  local containers=$(kgspo $1 ${2:-1} -o=custom-columns=":.spec.containers[*].name" --no-headers)
  local container=${3:-${containers%,*}} # Use first by default (prefix match) unless 3rd argument specified.
  local shell="bash"
  kubectl exec -it $(kgspo $1 ${2:-1} -o=custom-columns=":metadata.name" --no-headers) -n $(kgspo $1 -o=custom-columns=":metadata.namespace" --no-headers | n 1) -c $container $shell
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
alias -g nh="--no-headers"
alias -g oj="-o json | jq '.'"
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
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

# Get RFC3339 UTC "Zulu" format to paste into stackdriver logs
function st() { echo "timestamp >= \"$(date +%Y-%m-%dT%TZ -u --date="$1")\"" }

function evict {
  kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete pods \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c
}
