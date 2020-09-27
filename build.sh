echo setting repo dir
export repo_dir=$PWD

echo configuring build
. ~/highly-available-api-config.sh

echo getting infrastructure
cd ${repo_dir}/terraform
terraform init
. terraform-apply.sh

echo deploying build env 
cd ${repo_dir} 
. scripts/helm-deploy-build.sh 

echo waiting for builder to be deployed 
python scripts/wait_for_build.py 
if [ $? = 1 ]; then
  echo failed to deploy build 
  exit 1
fi


