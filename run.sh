WORKDIR_PATH=$1

DOCKER_NAME=kinfu
DOCKER_BINARY=nvidia-docker
DOCKER_RUN_NAME=kinfu_inst

$DOCKER_BINARY run -i -t --network=host -e DISPLAY=$DISPLAY --volume $XAUTH:/root/.Xauthority -d --rm  -p 8000:8888 -p 6006:6006 --name $DOCKER_RUN_NAME $DOCKER_NAME

# $DOCKER_BINARY exec $DOCKER_NAME bash -c \
#     "tmux new -d 'jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token='"

# $DOCKER_BINARY exec $DOCKER_NAME bash -c \
#     "tmux new -d 'tensorboard --logdir=./tensor_logs'"