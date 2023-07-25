# Apply
alias k=kubectl \

# Apply two yaml files
k apply -f k8s-nginx-web.yaml -f nginx.yaml

# Delete all resources of the two yaml files
k delete -f k8s-nginx-web.yaml -f nginx.yaml
