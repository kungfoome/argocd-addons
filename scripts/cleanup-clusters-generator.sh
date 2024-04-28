#!/usr/bin/env bash

scriptPath="$(dirname "$0")"

. ${scriptPath}/cluster_config.sh

printf "\n\n"

# Cleanup
printf "\n###### START: Cleanup k3d Clusters ########\n\n"
for cluster in "${clusters[@]}"; do
  printf "k3d cluster rm %s\n" "${cluster}"
done
printf "\n###### END: Cleanup k3d Clusters ########\n\n"