# **Jenkins in Docker Container**

## Resume
In this project we practice Jenkins and Docker. We'll create a simple pipeline to
connect with GitHub.

For now, the `server.py` it's a simple "Helo World" build with **FastAPI**. Maybe in the future we'll improve
the server.


Jenkins will run the test, build and deploy the server.

## Files
- `docker_setup.mk`: This Makefile allows user execute to run all docker commands associated with this project.

    - `make -f docker_setup.mk run`: Run a container with the latest Jenkins image on Docker Hub.
    - `make -f docker_setup.mk kill`: Stop and Remove the container.
    - `make -f docker_setup.mk logs`: Show the logs of the container.
    - `make -f docker_setup.mk stop`: Stop the container.
    
- `server_setup.mk`: This Makefile allows user execute to run all server commands associated with this project.

    - `make -f server_setup.mk start`: Start the server.
