docker login \ 
docker build . -t gasstin/k8s-test-web \ 
docker push gasstin/k8s-test-web \ 

# Build version 2.0.0
docker build . -t gasstin/k8s-test-web:2.0.0 \ 
docker push gasstin/k8s-test-web:2.0.0 \

