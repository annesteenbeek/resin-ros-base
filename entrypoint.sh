#!/bin/bash
set -e # exit if returns nonzero

# setup ROS env
source "${ROS_INSTALL_DIR}/setup.bash"

# setup ROS networking
export ROS_HOSTNAME="LOCALHOST"
export ROS_MASTER_URI="http://localhost:11311"

exec "$@"
