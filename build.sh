## color stdout 
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e ${GREEN}setting repo dir...${NC}
export repo_dir=$PWD

echo -e ${GREEN}configuring build...${NC}
. ~/highly-available-api-config.sh

echo -e ${GREEN}getting infrastructure...${NC}
cd ${repo_dir}/terraform
terraform init
. terraform-apply.sh
cd ${repo_dir} 

echo -e ${GREEN}docker login...${NC}
. ${repo_dir}/secret/acr/get_acr_access_credentials.sh

echo -e ${GREEN}getting .kube config...${NC}
. ${repo_dir}/scripts/get-kubeconfig-azure.sh 

echo -e ${GREEN}upload registry access credentials...${NC}
. ${repo_dir}/scripts/deploy-secrets.sh

echo -e ${GREEN}generate cookie token...${NC}
. ${repo_dir}/secret/cookie/make-cookie-token.sh

echo -e ${GREEN}generate tls cert...${NC}
. ${repo_dir}/secret/cert/make-cert.sh
. ${repo_dir}/secret/cert/upload-cert.sh

echo -e ${GREEN}deploying build env...${NC} 
. ${repo_dir}/scripts/helm-deploy-build.sh 

echo -e ${GREEN}waiting for builder to be deployed...${NC} 
python ${repo_dir}/scripts/wait_for_build.py 
if [ $? != 0 ]; then
  echo -e ${RED}failed to deploy build!${NC}
  exit 1
fi

echo -e ${GREEN}configuring build env...${NC}
. ${repo_dir}/scripts/copy-to-builder.sh 

echo -e ${GREEN}buidling containers...${NC} 
kubectl exec -it build -- /bin/sh /build/highly-available-api/scripts/build-containers.sh 

if [ $? != 0 ]; then 
  echo -e ${RED}api build failed!${NC} 
  exit 1
fi 

echo -e ${GREEN}tearing-down build env...${NC} 
. ${repo_dir}/scripts/helm-tear-down-build.sh

echo -e ${GREEN}deploying ingress controller...${NC} 
. ${repo_dir}/scripts/deploy-nginx-controller.sh 

echo -e ${GREEN}waiting for ingress controller to deploy...${NC} 
python ${repo_dir}/scripts/wait_for_nginx.py 

echo -e ${GREEN}deploying api...${NC} 
. ${repo_dir}/scripts/helm-deploy-api.sh 

echo -e ${GREEN}waiting for database to deploy...${NC} 
python ${repo_dir}/scripts/wait_for_db.py 

echo -e ${GREEN}initializing database...${NC} 
. ${repo_dir}/scripts/init-db.sh 
