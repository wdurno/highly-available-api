SERVER=$(cat ${repo_dir}/secret/acr/server)
IMAGE_NAME=${SERVER}/api:v1.0.0

helm upgrade api \
	${repo_dir}/helm/api/ \
	--install \
	--set image=${IMAGE_NAME} \
	--set client_id=${highly_available_api_client_id} \
	--set client_secret=${highly_available_api_client_secret} 
