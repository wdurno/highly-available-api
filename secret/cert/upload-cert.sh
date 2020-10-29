kubectl create secret tls tls-secret --key="${repo_dir}/secret/cert/cacert.key" \
	--cert="${repo_dir}/secret/cert/cacert.crt"
