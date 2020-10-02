if [ -z ${repo_dir} ] 
then 
  echo ERROR! repo_dir not set! Run from build.sh 
  exit 1
fi

az acr login --name AzureContainerRegsitry1 --expose-token | \
python unpack_acr_json.py  
