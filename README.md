# highly-available-api

Deploy a stateless, highly-available API in Azure Kubernetes Servicei (AKS) with OAuth2. Features
- Terraform-automated deployment
- Azure Active Directory (AAD)-driven OAuth2
- Helm charts provide a clean abstraction layer
- Highly-automated build and deployment 

## configure

1. Setup an AAD envrionment, including a registered application with a `client_secret`.
2. Choose an available domain name. 
3. Copy `highly-available-api-config.sh` to `$HOME` and populate it. 

## build and deploy 

A lot happens when you start the build. First, infrastructure is allocated with Terraform, including deployment of an Azure Container Registry (ACR) and single AKS instance. Then, secrets are securely generated and uploaded. Next, a Docker-in-Docker image is deployed, used to build relevant containers, then is torn-down. Next, just-built containers are deployed via Helm charts. Finally, the backend database is initialzied. 

This demo is optimized for automation and illustration. Normally, build and production environments should be separated.

Manual steps required for building and deployment:

1. Run `bash build.sh` 
2. Once the build is done, manually configure the Azure Public IP to expose your domain.

## demo

Navigate to your domain and login. Watch the stateless, highly-available API count your visits and report the API pod name which serviced your request.
```
{"pod-name":"xkymgqrrhp","total-visits":"2"}
{"pod-name":"nimslepznw","total-visits":"3"}
```

## clean-up 

1. Navigate to `terraform/`
2. Run `terraform-destroy.sh`

## potential improvements

1. Public IP configuration should be fully-automated. 

