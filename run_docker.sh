#! /bin/bash

docker run \
    --net host \
    --gpus all \
    --rm \
    -v ~/Nenakhov/ros_ws:/ws \
    -it \
    --name cv \
    ivan/cv 