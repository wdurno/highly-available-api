. ~/highly-available-api-config.sh

cluster_name=ha-api-aks

az aks get-credentials --name ${cluster_name} --resource-group ${highly_available_api_resource_group_name} --overwrite-existing
