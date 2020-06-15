POSTGRES_POD=$(kubectl get pods | tail -n+2 | grep postgres | awk '{print $1;}')
kubectl exec -it $POSTGRES_POD -- psql -U postgres -c "CREATE DATABASE api"
kubectl exec -it $POSTGRES_POD -- psql -U postgres -d api -c "CREATE TABLE visits(total INT4)"
kubectl exec -it $POSTGRES_POD -- psql -U postgres -d api -c "INSERT INTO visits(total) VALUES (0)"
