## allocate k8s infrastructure 
cd ../terraform
terraform init
terraform apply -auto-approve
cd ../scripts
gcloud container clusters get-credentials ha-demo-cluster --zone us-central1-a --project gdax-dnn
## install api on k8s 
helm install api ../helm/api/
## initialize database 
POSTGRES_POD=$(kubectl get pods | tail -n+2 | grep postgres | awk '{print $1;}') 
kubectl exec -it $POSTGRES_POD -- psql -U postgres -c "CREATE DATABASE api" 
kubectl exec -it $POSTGRES_POD -- psql -U postgres -d api -c "CREATE TABLE visits(total INT4)" 
kubectl exec -it $POSTGRES_POD -- psql -U postgres -d api -c "INSERT INTO visits(total) VALUES (0)" 
