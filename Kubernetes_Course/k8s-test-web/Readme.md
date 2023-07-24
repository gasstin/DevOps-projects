# Kubernetes Test Web Application - README

This repository contains scripts and instructions for setting up and managing a Kubernetes test web application using Docker and `kubectl`.

## Prerequisites

Before you begin, ensure you have the following installed:

1. Docker: Install Docker on your local machine. You can download it from the official Docker website: https://www.docker.com/get-started

2. kubectl: Install kubectl to interact with your Kubernetes cluster. You can find installation instructions here: https://kubernetes.io/docs/tasks/tools/install-kubectl/

3. minikube: If you don't have access to a Kubernetes cluster, you can use minikube to set up a local single-node Kubernetes cluster. Install minikube from the official website: https://minikube.sigs.k8s.io/docs/start/

## Script 1: Docker Image Build and Push

`docker-build.sh` - This script demonstrates how to build and push a Docker image to the Docker Hub registry.

## Script 2: Kubernetes Deployment and Services

`k8s-web-deployment.sh` - This script shows how to create a Kubernetes deployment and expose services for the web application.

## Script 3: Updating Deployment and Rollout Status

`k8s-web-update.sh` - This script demonstrates updating the image of the Kubernetes deployment and checking the rollout status. Finally, deletes all resources.