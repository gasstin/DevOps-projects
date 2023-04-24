
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

# Stop and Remove the container
kill:
	docker stop jenkins-python-app
	docker rm jenkins-python-app

# Logs of the container
logs:
	docker logs jenkins-python-app

# Build the image from the Dockerfile
build:
	docker image rm jenkins_dind
	docker build -t jenkins_dind .

# Stop the python app container
stop:
	docker stop jenkins-python-app
