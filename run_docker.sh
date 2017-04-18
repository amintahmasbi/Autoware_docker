#!/bin/bash

nohup docker rmi $(docker images -f "dangling=true" -q) < /dev/null > ./logs/build_log.txt 2>&1
nohup docker stop $(docker ps -a -q) < /dev/null > ./logs/build_log.txt 2>&1
nohup docker rm $(docker ps -a -q) < /dev/null > ./logs/build_log.txt 2>&1

nohup ./build_docker.sh < /dev/null > ./logs/build_log.txt 2>&1 

nohup docker network create ros_net > ./logs/build_log.txt 2>&1 
echo "Build was successful!" 

#sleep 1
nohup ./run_master.sh < /dev/null > ./logs/roscore_log.txt 2>&1 &
echo "Running ROS core as master!" 

#sleep 3
#nohup ./run_rviz.sh & < /dev/null > ./logs/rviz_log.txt 2>&1 &
#echo "Running ROS Rviz as Rviz!" 

sleep 1
nohup ./run_gazebo.sh < /dev/null > ./logs/gazebo_log.txt 2>&1 &
echo "Running gazebo server as gazebo!" 
