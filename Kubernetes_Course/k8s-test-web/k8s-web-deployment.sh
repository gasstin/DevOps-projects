# Alias
alias k=kubectl \ 

k create deployment k8s-test-hello --image=gasstin/k8s-test-hello \
# List the pods
k get pods
# Create service
k expose deployment k8s-test-hello --port=3000

# Inside the service
minikube ip >> minukube-ip.txt \ 
export MINIKUBEIP = cat minukube-ip.txt \ 
ssh docker@${MINIKUBEIP} # pass DCuser

# Scale deployment
k scale deployment k8s-test-hello --replicas=4

# Expose NodePort
k expose deployment k8s-test-hello --type=NodePort --port=3000 \ 
minikube service k8s-test-hello \ 

# LoadBalancer service
k expose deployment k8s-test-hello --type=LoadBalancer --port=3000 \ 
minikube service k8s-test-hello \ 

# Describe deployment
k describe deploy k8s-test-hello \


