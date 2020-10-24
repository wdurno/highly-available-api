echo setting repo dir...
export repo_dir=/build/highly-available-api 

echo docker login...
. ${repo_dir}/scripts/acr-login.sh 

echo get docker server...
export SERVER=$(cat ${repo_dir}/secret/acr/server) 
cat $SERVER

echo building api...
cd ${repo_dir}/api 
. docker-build-and-push.sh 

echo building oauth2...
cd ${repo_dir}/msal-auth
. docker-build-and-push.sh 
