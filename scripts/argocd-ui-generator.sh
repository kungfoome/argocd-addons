#!/usr/bin/env bash

scriptPath="$(dirname "$0")"

. ${scriptPath}/cluster_config.sh

printf "\n\n"

printf "\n###### START: LocalHost: Port Forward to ArgoCD ########\n\n"
printf "k3d kubeconfig merge %s -d\n" "${controlplane}"
printf "kubectl config use-context k3d-%s\n" "${controlplane}"
printf "kubectl port-forward svc/argocd-server -n argocd 9996:443\n"
printf "# Open https://localhost:9996\n"
printf "# Login: admin, Password: %s\n" "$(argocd admin initial-password -n argocd | head -n1)"
printf "\n###### END: LocalHost: Port Forward to ArgoCD ########\n\n"
