#!/usr/bin/env bash

scriptPath="$(dirname "$0")"

. ${scriptPath}/cluster_config.sh

printf "\n\n"

# Install dependencies
printf "apk add kubectl git curl \n"

## Install argocd
printf "\ncurl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64\n"
printf "mv argocd-linux-amd64 /usr/local/bin/argocd\n"
printf "chmod 555 /usr/local/bin/argocd\n"

## Install k3d
printf "\ncurl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash\n"

# Create clusters
printf "\n\n\n"
printf "###### START: Create Clusters ########\n\n"
for cluster in "${clusters[@]}"; do
  printf "k3d cluster create %s --network %s\n" "${cluster}" "${network}"
done
printf "\n###### END: Create Clusters ########\n\n"

# Get cluster configs
printf "\n###### START: Dump k8s Configs ########\n\n"
for cluster in "${clusters[@]}"; do
  printf "k3d kubeconfig get %s > %s/%s.yaml\n" "${cluster}" "${cluster_configs_path}" "${cluster}"
done
printf "\n###### END: Dump k8s Configs ########\n\n"

# Dump cluster configs to file
printf "\n###### START: Merge k8s Config ########\n\n"
configs="$(printf ":${cluster_configs_path}/%s.yaml" "${clusters[@]}")"
configs="${configs:1}"
echo "KUBECONFIG=${configs} kubectl config view --flatten > ${clusters_config}"
printf "\n###### END: Merge k8s Config ########\n\n"

# Fix cluster config and update to correct server
printf "\n###### START: Update k8s Config ########\n\n"
for cluster in "${clusters[@]}"; do
  echo "KUBECONFIG=${clusters_config} kubectl config set-cluster k3d-${cluster} --server="https://k3d-${cluster}-serverlb:6443""
done
printf "\n###### END: Update k8s Config ########\n\n"

# Install argocd
printf "\n###### START: Install ArgoCD ########\n\n"
printf "export KUBECONFIG=%s\n" "${clusters_config}"
printf "kubectl config use-context k3d-%s\n" "${controlplane}"
printf "kubectl create namespace argocd\n"
printf "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml\n"
printf "\n###### END: Install ArgoCD ########\n\n"

# Add clusters to argocd to be managed from control-plane
printf "\n###### START: Add Other Clusters to ArgoCD ########\n\n"
printf "kubectl config set-context --current --namespace=argocd\n"
printf "argocd login --core\n"
for cluster in "${clusters[@]:1}"; do
  printf "argocd cluster add k3d-%s --yes --name %s\n" "${cluster}" "${cluster}"
done
printf "\n###### END: Add Other Clusters to ArgoCD ########\n\n"
