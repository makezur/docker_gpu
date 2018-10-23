#!/bin/bash

# NAME=kinfu_test
# DOCKER_BINARY=nvidia-docker

# nvidia-docker build -t $NAME -f ./Dockerfile .

tmux new -s build -d 'sudo nvidia-docker build -t kinfu -f ./Dockerfile  . > build_new.log'
