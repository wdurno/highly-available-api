COOKIE=$(cat ${repo_dir}/secret/cookie/cookie-token)
SERVER=$(cat ${repo_dir}/secret/acr/server)
API_IMAGE_NAME=${SERVER}/api:v1.0.0
OAUTH2_IMAGE_NAME=${SERVER}/oauth2:v1.0.0 

helm upgrade api \
	${repo_dir}/helm/api/ \
	--install \
	--set api_image=${API_IMAGE_NAME} \
	--set oauth2_image=${OAUTH2_IMAGE_NAME} \
	--set client_id=${highly_available_api_client_id} \
	--set client_secret=${highly_available_api_client_secret} \
	--set tenant_id=${highly_available_api_tenant_id} \
        --set cookie_token=${COOKIE} \
	--set host=${highly_available_api_host} 
