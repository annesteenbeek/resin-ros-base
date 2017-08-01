#!/bin/bash
set -e # exit if returns nonzero

# setup ROS env
source "${ROS_INSTALL_DIR}/setup.bash"
source "${CATKIN_DIR}/dev/setup.bash"

# setup ROS networking
export ROS_HOSTNAME="localhost"
export ROS_MASTER_URI="http://localhost:11311"

exec "$@"
