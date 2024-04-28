#!/usr/bin/env bash

scriptPath="$(dirname "$0")"

. ${scriptPath}/cluster_config.sh

printf "\n\n"

printf "\n###### START: Cleanup Localhost Environment ########\n\n"
printf "docker network rm %s\n" "${network}"
printf "kubectl config delete-context k3d-%s\n" "${controlplane}"
printf "kubectl config delete-cluster k3d-%s\n" "${controlplane}"
printf "kubectl config delete-user admin@k3d-%s\n" "${controlplane}"
printf "\n###### END: Cleanup Localhost Environment ########\n\n"
