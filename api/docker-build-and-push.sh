IMAGE_NAME=${SERVER}/api:v1.0.0
cp ${repo_dir}/src/python/auth.py app/auth.py 
docker build . -t $IMAGE_NAME --rm=false 
docker push $IMAGE_NAME
