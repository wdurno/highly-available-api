SERVER=$(cat ${repo_dir}/secret/acr/server) 
TOKEN_PATH=${repo_dir}/secret/acr/token

cat $TOKEN_PATH | docker login $SERVER --username 00000000-0000-0000-0000-000000000000 --password-stdin
