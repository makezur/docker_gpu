#!/bin/bash


NAME=kochka_gpu


nvidia-docker build -t $NAME -f ./Dockerfile .