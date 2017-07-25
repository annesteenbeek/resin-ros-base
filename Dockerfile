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

ENV ROS_INSTALL_DIR="/opt/ros/${ROS_DISTRO}" \
    CATKIN_DIR="/usr/src/catkin_ws"

# add sources
RUN echo "deb http://packages.ros.org/ros/ubuntu jessie main" > \
    /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \ 
    --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# apt gets
RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
    python-dev \
    python-pip \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    python-catkin-tools \
    python-rospkg \
    build-essential \
    git-core
#     rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${CATKIN_DIR}/src ${ROS_INSTALL_DIR}

WORKDIR "${CATKIN_DIR}"

RUN rosdep init \
    && rosdep update \
    && rosinstall_generator ${ROS_CONFIG} \
        --rosdistro ${ROS_DISTRO} --deps --tar > .rosinstall \
    && wstool init src .rosinstall \
    && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y \
        --skip-keys python-rosdep \
        --skip-keys python-rospkg \
        --skip-keys python-catkin-pkg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && catkin init \
    && catkin config --install --install-space "${ROS_INSTALL_DIR}" \
        --cmake-args -DCMAKE_BUILD_TYPE=Release \
    && catkin build --no-status --no-summary --no-notify \
    && catkin clean -y --logs --build --devel \
    && rm -rf src/*
   
# Setup modules
RUN git clone -b ${ROS_DISTRO}-devel https://github.com/ros/ros_tutorials.git \
    src/ros_tutorials
RUN catkin build roscpp_tutorials

# Finish setup
COPY ./entrypoint.sh /usr/

ENTRYPOINT ["bash", "/usr/entrypoint.sh"]

CMD ["roslaunch", "roscpp_tutorials", "talker_listener.launch"]

# TODO user namespace
