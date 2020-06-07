INGRESS=$(kubectl get ingress | tail -n+2 | grep demo-ingress | awk '{print $3;}')
curl $INGRESS
