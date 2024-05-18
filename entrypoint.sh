#!/bin/bash

# Source the ROS setup script
source /opt/ros/noetic/setup.bash

# Start the SSH service
service ssh start

# Start the XRDP service
service xrdp start

# Keep the container running
tail -f /dev/null
