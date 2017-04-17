
### main file
This is them main file you should run and put your nodes here to run or use `nvidia-docker` to run your stuff

```
./run_docker.sh 
```
### connect to one of the containers
provide a container name to connect
find the names by: `docker ps`
```
./connect_to_docker rviz
```
after connecting make sure to source ROS:
```
source /ros_entrypoint.sh
```
