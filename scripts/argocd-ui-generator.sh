#!/usr/bin/env bash

scriptPath="$(dirname "$0")"

. ${scriptPath}/cluster_config.sh

printf "\n\n"

printf "\n###### START: LocalHost: Port Forward to ArgoCD ########\n\n"
printf "k3d kubeconfig merge ${controlplane} -d\n"
printf "kubectl config use-context k3d-${controlplane}\n"
printf "kubectl port-forward svc/argocd-server -n argocd 9996:443\n"
printf "# Open https://localhost:9996\n"
printf "# Login: admin, Password: $(argocd admin initial-password -n argocd | head -n1)\n"
printf "\n###### END: LocalHost: Port Forward to ArgoCD ########\n\n"
