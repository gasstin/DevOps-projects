FROM python:3.10-alpine

COPY ./setup_environment.sh /app/setup_environment.sh
COPY ./app /app

WORKDIR /app

EXPOSE 5000

RUN apk update && apk add --no-cache sudo gcc curl openssh-client python3-dev

RUN sh ./setup_environment.sh

RUN python3 -m pip install -r requirements.txt && rm -rf requirements.txt