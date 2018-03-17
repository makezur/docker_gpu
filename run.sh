WORKDIR_PATH=$1

DOCKER_NAME=kochka_gpu
DOCKER_BINARY=nvidia-docker

$DOCKER_BINARY run -i -t -d --rm \
               -v $WORKDIR_PATH:/playground/ \
               -p 8000:8888 -p 6006:6006 \
               --name $DOCKER_NAME \
               $DOCKER_NAME

$DOCKER_BINARY exec $DOCKER_NAME bash -c \
    "nohup jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token=  </dev/null >/dev/null &"

$DOCKER_BINARY exec $DOCKER_NAME bash -c \
    "nohup tensorboard --logdir=./tensor_logs </dev/null >/dev/null &"