. ~/highly-available-api-config.sh
terraform plan \
  -var="subscription_id=${highly_available_api_subscription_id}"\
  -var="tenant_id=${highly_available_api_tenent_id}"\
  -var="resource_group_name=${highly_available_api_resource_group_name}"
