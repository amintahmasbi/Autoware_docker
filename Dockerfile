From gcr.io/tensorflow/tensorflow:0.12.1-devel-gpu

MAINTAINER Amin Tahmasbi <amintahmasbi@gmail.com>

# setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# setup keys
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup keys and setup sources.list for gazebo 2.2.6
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu trusty main" > /etc/apt/sources.list.d/gazebo-latest.list
RUN apt-key adv --fetch-keys http://packages.osrfoundation.org/gazebo.key 

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO indigo

RUN apt-get update && apt-get install -y \
    ros-indigo-ros-core \
    && rm -rf /var/lib/apt/lists/*

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-base \
    && rm -rf /var/lib/apt/lists/*

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop-full \
    && rm -rf /var/lib/apt/lists/*

#RUN apt-get update && apt-get install -y \
#    ros-indigo-turtlesim \
#    && rm -rf /var/lib/apt/lists/*

#RUN apt-get update && apt-get install -y \
#    ros-indigo-ros-tutorials \
#    ros-indigo-common-tutorials \
#    && rm -rf /var/lib/apt/lists/*

# install autoware dependencies
RUN apt-get update && apt-get install -y \
	ros-indigo-nmea-msgs \
	ros-indigo-nmea-navsat-driver \
	ros-indigo-sound-play \
	ros-indigo-jsk-visualization \
	ros-indigo-grid-map \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	ros-indigo-controller-manager \
	ros-indigo-ros-control \
	ros-indigo-ros-controllers \
	ros-indigo-gazebo-ros-control \
	ros-indigo-sicktoolbox \
	ros-indigo-sicktoolbox-wrapper \
	ros-indigo-joystick-drivers \
	ros-indigo-novatel-span-driver \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	libnlopt-dev \
	freeglut3-dev \
	qtbase5-dev \
	libqt5opengl5-dev \
	libssh2-1-dev \
	libarmadillo-dev \
	libpcap-dev \
	gksu \
	libgl1-mesa-dev \
	&& rm -rf /var/lib/apt/lists/*

# setup environment for gazebo
EXPOSE 11345

#X server and monitor
# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV DEV_HOME /home/developer


# Setting up autoware
RUN mkdir -p $DEV_HOME/Autoware
WORKDIR $DEV_HOME
#ADD /home/hradt/git/Autoware Autoware
#RUN cd $DEV_HOME/Autoware/ros/src

#installing Autoware
#RUN catkin_init_workspace
#RUN cd $DEV_HOME/Autoware/ros
#RUN ./catkin_make_release

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["gzserver","bash"]



