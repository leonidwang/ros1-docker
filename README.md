# ros1-docker
Docker image for ROS1 system with XRDP and SSH support
- Based on Ubuntu 20.04, with ```ros-noetic-desktop-full``` and related packages installed.
- XRDP with XFCE desktop environment.
- OpenSSH server configured.

# default settings
Default username and password is ```ros:ros```

# build docker image
```
docker build -t ros1-xrdp .
```

# run docker
XRDP and SSH are well known services.

It's possible that the host's default XRDP/SSH port 3389/22 have been taken.

Change the port mapping as desired.

```
docker run --rm -d -p 3389:3389 -p 22:22 --name ros ros1-xrdp
```

# stop docker
```
docker stop ros
```
