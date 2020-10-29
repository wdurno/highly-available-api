if [ -z ${repo_dir} ]
then
  echo ERROR! repo_dir not set! Run from build.sh
  exit 1
fi

## docker registry 
kubectl delete secret acr-creds 
kubectl create secret docker-registry acr-creds \
  --docker-server=$(cat ${repo_dir}/secret/acr/server) \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$(cat ${repo_dir}/secret/acr/token)
