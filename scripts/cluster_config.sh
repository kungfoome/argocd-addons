#!/usr/bin/env bash

# Variables used for cluster creation
export controlplane="argo-control-plane"
export clusters=("${controlplane}" "argo-dev" "argo-prod")
export cluster_configs_path="/tmp"
export clusters_config="/tmp/argocd-clusters.yaml"
export network="argo-network"
