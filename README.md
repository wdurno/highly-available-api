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
. 1-spin-up.sh
. 2-init-db.sh
```

## demo 

After the ingress is fully deployed (which can take several minutes), you'll be able to ping your highly-available API. The API responds with the unique ID of the API pod to demonstrate successful load balancing. Pinging the cluster returns these IDs randomly. 

```
cd scripts
. 3-ping.sh
# returns "jigsbiktaf"
. 3-ping.sh 
# piaxzmukdm
. 3-ping.sh 
# pjtptrnzib
. 3-ping.sh
# piaxzmukdm
```

## clean-up 

```
. 4-spin-down.sh 
```

