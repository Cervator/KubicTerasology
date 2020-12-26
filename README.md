## Kubic Terasology

A setup for making [Terasology](https://terasology.org/) work in a Kubernetes cluster, with extra conveniences around config files (stored in ConfigMaps)

An eventual goal is to include automatic server hibernation to keep hosting costs down while using [ChatOps](https://docs.stackstorm.com/chatops/chatops.html) for server maintenance tasks (for instance: asking a bot on Discord to please start up the server hosting map `x` when somebody wants to play there)

Uses the [Docker image](https://hub.docker.com/repository/docker/cervator/terasology-server) from https://github.com/Cervator/docker-terasology

Is part of the Kubic game server series started with https://github.com/Cervator/KubicArk


## Instructions

Apply the resources to a target Kubernetes cluster with some attention paid to order (config maps and storage before the deployment). Consider using the `apply-server.sh` and `delete.sh` scripts

* `apply-server.sh tera1` would create a server "tera1" (and any missing global resources) with server-specific config from that directory
* `apply.server.sh tera2` would likewise create "tera2"
* `delete.sh tera1` would delete the tera1 specific resources (but *not* global ones)
* `delete.sh` would delete *only* global resources, but not servers

As the exposing of servers happen using a NodePort you need to manually add a firewall rule as well, Google Cloud example:

`gcloud compute firewall-rules create tera1 --allow tcp:31101` would prepare the ports for tera1

*Note:* There are placeholder passwords in `tera-server-secrets.yaml` - you'll want to update these _but only locally where you run `kubectl` from_ - don't check your passwords into Git!


## Configuration files

To easily configure a given Terasology server via Git without touching the server several server config files are included via Kubernetes Config Maps (CMs)

* `override.cfg` - contains server config meant to override generated defaults
* `whitelist.txt` - sample of an approach that'd let us include player-related config files


### Making changes

After initial config and provisioning you can change the CMs either via files or directly, such as via the nice Google Kubernetes Engine dashboard. Then simply delete the server pod (not the deployment) via dashboard or eventually using ChatOps. The persistent volume survives including the installed game server files, so it may not make an appreciable difference to restart the server or blow it up. The deployment will auto-recreate the pod if deleted.


### Gory details

On initial creating of a game server pod the CMs associated with that pod will be mapped to a projected volume in `/terasology-config/` - essentially meaning you'll get files there representing the CMs. The game server will be configured to load them directly from that location.


## Connecting to your server

Find an IP to one of your cluster nodes (the longer lived the better) by using `kubectl get nodes -o wide`, then add the right port from your server set, for instance `31101` for tera1 `[IP]:[port]` then add that server in-game as a listed server. The server generally comes online pretty fast but crashes easily, you can watch it with `kubectl logs <server-name>-<gibberish>` (adjust accordingly to your pod name, seen with `kubectl get pods`)


## License

This project is licensed under Apache v2.0 with contributions and forks welcome. The associated Terasology resources are licensed as per their project descriptions.
