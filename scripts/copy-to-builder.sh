kubectl exec -it build -- mkdir /build
kubectl cp ${repo_dir} build:/build
kubectl cp ~/highly-available-api-config.sh build:/root 
