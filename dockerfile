# Use the official Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the sources list to use USTC mirrors
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.ustc.edu.cn/ubuntu/|g' /etc/apt/sources.list && \
    echo 'Acquire::https::mirrors.ustc.edu.cn::Verify-Peer "false";' > /etc/apt/apt.conf.d/99disable-verify-peer

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    sudo \
    xrdp \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    x11-xserver-utils \
    wget \
    curl \
    gnupg2 \
    lsb-release \
    openssh-server

# Create a user with sudo privileges
RUN useradd -m -s /bin/bash ros && \
    echo 'ros:ros' | chpasswd && \
    adduser ros sudo

# Setup XRDP
RUN adduser xrdp ssl-cert

# Configure XRDP to use XFCE4
RUN echo xfce4-session > /home/ros/.xsession && \
    chown ros:ros /home/ros/.xsession

# Add ROS repository and key
RUN curl -sSL 'http://packages.ros.org/ros.key' | apt-key add - && \
    sh -c 'echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    echo 'Acquire::https::mirrors.ustc.edu.cn::Verify-Peer "false";' >> /etc/apt/apt.conf.d/99disable-verify-peer && \
    apt-get update && \
    apt-get install -y ros-noetic-desktop-full python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential && \
    echo "source /opt/ros/noetic/setup.bash" >> /home/ros/.bashrc

# Source ROS setup script and initialize rosdep
RUN bash -c "source /opt/ros/noetic/setup.bash && sudo rosdep fix-permissions && rosdep init && rosdep update"

# Enable SSH service
RUN systemctl enable ssh

# Set up the entrypoint script to start SSH and XRDP services
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the XRDP and SSH ports
EXPOSE 3389 22

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
