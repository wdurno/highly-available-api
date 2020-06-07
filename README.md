# highly-available-api

Deploys a load-balanced API behind an ingress and `LoadBalancer` service. The ingress enables additional configuration. Services can be externally visibile. The ingress is used for additional configurability. 

## build 

```
cd docker/api
. docker-build.sh 
```

## deploy 

```
cd scripts
. spin-up-cluster.sh
. deploy-k8s.sh
```

## demo 

After the ingress is fully deployed (which can take several minutes), you'll be able to ping your highly-available API. The API responds with the unique ID of the API pod to demonstrate successful load balancing. Pinging the cluster returns these IDs randomly. 

```
cd scripts
. ping.sh
# returns "jigsbiktaf"
. ping.sh 
# piaxzmukdm
. ping.sh 
# pjtptrnzib
. ping.sh
# piaxzmukdm
```

