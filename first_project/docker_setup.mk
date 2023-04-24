
# Run Docker container with Jenkins
run:
	docker run --name jenkins-python-app --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --volume "$$HOME":/home \
  --restart=on-failure \
  --env JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" \
  jenkins_dind

# Recreate the container
recreate: kill build run


# Stop and Remove the container
kill:
	docker stop jenkins-python-app || true
	docker rm jenkins-python-app || true
	docker rmi jenkins_dind:latest || true

# Logs of the container
logs:
	docker logs jenkins-python-app

# Build the image from the Dockerfile
build:
	docker build -t gasstin/jenkins_dind:latest .

# Stop the python app container
stop:
	docker stop jenkins-python-app
