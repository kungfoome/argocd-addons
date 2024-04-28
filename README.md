# Requirements

These are the dependencies required to be installed on the local machine.

- docker desktop
- kubectl cli
- argocd cli
- k3d cli

# Start DIND Container

To make the overall changes universal, I decided to have a docker container connect to the docker socket. This way we can run linux commands, even if you are running windows.

If you change the network, ensure that gets updated in the [cluster_config.sh](./scripts/cluster_config.sh) script.

```shell
docker network create argo-network
docker run --rm -it --privileged --network argo-network -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/scripts:/scripts docker:latest sh -c "apk add bash && /bin/bash"
```

# Running The Commands

In each section, there will be a script that will print the commands that should be run. I decided to do it this way as there is some back and forth between the localhost and the container. I tried to make it so that most of the commands are run inside the dind container and that way anyone can follow along, no matter the operating system of the localhost.

Also, by printing the commands needed, you can change the config to something you might like better and it should still work the same. You can add more clusters or remove whatever clusters you want.

# Bootstrap ArgoCD Clusters

Within the dind container, run

```shell
/scripts/bootstrap-argocd-generator.sh
```

This will print all the commands needed to run and install the argocd clusters. You can copy all the commands and just run them or go through each section. This allows you to go at your own pace and be comfortable running the commands.

# Open ArgoCD UI

Within the dind container, run

```shell
/scripts/argocd-ui-generator.sh
```

This will give the command to run the localhost machine. You will need to run the port forward command on the localhost and then you can open a web browser to see the ArgoCD UI. The username and password will be dumped to the terminal as well.

# Cleanup ArgoCD Clusters

Within the dind container, run

```shell
/scripts/cleanup-clusters-generator.sh
```

This will cleanup all the k3d clusters. This should be run within the dind container.

# Cleanup Localhost

Within the dind container, run

```shell
/scripts/cleanup-localhost-generator.sh
```

Copy this command and exit the dind container. You can then run those commands to remove and cleanup anything that was done from the localhost and start from a clean slate.
