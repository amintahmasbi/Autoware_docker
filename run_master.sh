#!/bin/bash
nvidia-docker run -t --rm \
    --net ros_net \
    --name master \
    autoware \
    roscore

