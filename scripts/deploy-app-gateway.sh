## online guide 
## https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing 

. ~/highly-available-api-config.sh

## enable preview feature 
az feature register --name AKS-IngressApplicationGatewayAddon --namespace microsoft.containerservice

## refresh 
az provider register --namespace Microsoft.ContainerService

## ensure preview is installed 
az extension add --name aks-preview
az extension list

az extension update --name aks-preview
az extension list

## deploy gateway 
az network public-ip create -n myPublicIp -g ${highly_available_api_resource_group_name} --allocation-method Static --sku Standard
az network vnet create -n HaApiAppGatewayVNet -g ${highly_available_api_resource_group_name} --address-prefix 11.0.0.0/8 --subnet-name mySubnet --subnet-prefix 11.1.0.0/16 
az network application-gateway create -n myApplicationGateway -l ${highly_available_api_location} -g ${highly_available_api_resource_group_name} --sku Standard_v2 --public-ip-address myPublicIp --vnet-name HaApiAppGatewayVNet --subnet mySubnet

## engable AGIC for cluster 
appgwId=$(az network application-gateway show -n myApplicationGateway -g ${highly_available_api_resource_group_name} -o tsv --query "id") 
az aks enable-addons -n ha-api-aks -g ${highly_available_api_resource_group_name} -a ingress-appgw --appgw-id $appgwId

## peer gateway vnet with cluster vnet 
nodeResourceGroup=$(az aks show -n ha-api-aks -g ${highly_available_api_resource_group_name} -o tsv --query "nodeResourceGroup")
aksVnetName=$(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")
az network vnet peering create -n AppGWtoAKSVnetPeering -g ${highly_available_api_resource_group_name} --vnet-name HaApiAppGatewayVNet --remote-vnet $aksVnetId --allow-vnet-access

appGWVnetId=$(az network vnet show -n HaApiAppGatewayVNet -g ${highly_available_api_resource_group_name} -o tsv --query "id")
az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access

