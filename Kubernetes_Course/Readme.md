# Kubernetes Course - Course Materials

Welcome to the Kubernetes course! This repository contains the course materials for learning Kubernetes. Below is an overview of the files and folders included in this repository.

## Folders

### 1. `k8s-test-web`

This folder contains a minimun NodeJs app and some scripts to use kubectl CLI to deploy, apply, manage or delete services and pods.

### 2. `k8s-nginx-web`

This folder contains a NodeJs app to connect to nginx service. Scripts inside the folder show how to deploy two yaml files at the same time. 


## YAML Files

### 1. `deployment.yaml`

The `deployment.yaml` file is a Kubernetes manifest for creating a deployment. Deployments are used to manage the lifecycle of replica sets, which in turn manage pods. This file contains the specifications for the desired deployment.

### 2. `service.yaml`

The `service.yaml` file is a Kubernetes manifest for creating a service. Services provide a stable endpoint to access a set of pods in a deployment. This file defines the desired service for your application.

### 3. `k8s-nginx-web.yaml`

The `k8s-nginx-web.yaml` file is a Kubernetes manifest specific to an NGINX web server. This file demonstrates how to deploy an NGINX container in a Kubernetes cluster.

### 4. `k8s-test-web.yaml`

The `k8s-test-web.yaml` file is a Kubernetes manifest for a test web application. It is meant to be used for testing purposes and to demonstrate various Kubernetes concepts.

## Getting Started

To get started with the course, follow these steps:

1. Clone this repository to your local machine using Git:
