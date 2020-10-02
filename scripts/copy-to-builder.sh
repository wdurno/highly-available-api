echo making build dir 
kubectl exec -it build -- mkdir /build
echo copying repo to build dir 
kubectl cp ${repo_dir} build:/build
echo copying config to home 
kubectl cp ~/highly-available-api-config.sh build:/root 
