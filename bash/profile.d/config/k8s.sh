#!/bin/bash
#
# The below scripts ease use of working with k8s.

function change-ns() {
    namespace=$1
    if [ -z $namespace ]; then
        echo "Please provide the namespace name: 'change-ns dev'"
        return 1
    fi

    kubectl config set-context $(kubectl config current-context) --namespace $namespace
}
