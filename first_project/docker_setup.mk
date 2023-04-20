# Run Docker container with Jenkins
run:
	docker run -p 8080:8080 -p 50000:50000 -d --name jenkins_in_docker --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
# Stop and Remove the container
kill:
	docker stop jenkins_in_docker
	docker rm jenkins_in_docker
# Logs of the container
logs:
	docker logs jenkins_in_docker