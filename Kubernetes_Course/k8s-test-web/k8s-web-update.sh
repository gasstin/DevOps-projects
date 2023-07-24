# Set updated image
k set image deployment k8s-test-web k8s-test-web=gasstin/k8s-test-web:2.0.0

# Rollout status
k rollout status deploy k8s-web-test

# Delete all services
k delete all --all