## allocate k8s infrastructure 
cd ../terraform
terraform init
terraform apply -auto-approve
cd ../scripts
gcloud container clusters get-credentials ha-demo-cluster --zone us-central1-a --project gdax-dnn
## install api on k8s 
helm install api ../helm/api/
