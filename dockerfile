FROM resin/raspberrypi3-buildpack-deps:jessie
# FROM debian:jessie

ENV INITSYSTEM="on" \
    TERM="xterm" \
    PYTHONIOENCODING="UTF-8" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"

# Set ROS variables
ENV ROS_DISTRO="kinetic" \
    ROS_CONFIG="ros_base" 

ENV ROS_INSTALL_DIR="/opt/ros/${ROS_DISTRO}"

# add sources
RUN echo "deb http://packages.ros.org/ros/ubuntu jessie main" > \
    /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \ 
    --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# apt gets
RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
    ros-kinetic-ros-base \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    python-catkin-tools \
    build-essential 
#     rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/catkin_ws/src 

WORKDIR /usr/src/catkin_ws

RUN rosdep init \
    && rosdep update \
    && catkin init 
   
WORKDIR /usr

COPY ./entrypoint.sh .

ENTRYPOINT ["bash", "entrypoint.sh"]

CMD ["bash"]

# TODO user namespace
