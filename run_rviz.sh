nvidia-docker run -t \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --workdir="/home/developer" \
    --net ros_net \
    --name rviz \
    --env ROS_HOSTNAME=rviz \
    --env ROS_MASTER_URI=http://master:11311 \
    autoware \
    rviz
