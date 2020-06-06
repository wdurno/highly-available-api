IMAGE_NAME=gcr.io/gdax-dnn/ha-api/api:v0.0.7
docker build . -t $IMAGE_NAME --rm=false 
docker push $IMAGE_NAME
