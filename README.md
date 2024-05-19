# ros1-docker
Docker image for ROS1 system with XRDP and SSH support
- Based on Ubuntu 20.04, with ```ros-noetic-desktop-full``` and related packages installed.
- XRDP with XFCE desktop environment configured.
- OpenSSH server configured.
- Dockerfile uses USTC mirror (mirrors.ustc.edu.cn), if you prefer official repo, feel safe to remove mirror configs.

# default settings
Default username and password is ```ros:ros```

# build docker image
```
docker build -t ros1-docker .
```

# pull image from DockerHub
A pre-built image was uploaded to DockerHub.
```
docker pull wangl34/ros1-docker:latest
```

# run docker
It's possible that the host's default XRDP/SSH port 3389/22 have been taken.

Change the port mapping as desired.

```
docker run --rm -d -p 3389:3389 -p 22:22 --name ros ros1-docker
```

# stop docker
```
docker stop ros
```

# application sandbox workaround
Applications like VisualStudio Code, Chromium requres sandbox which usually won't be satisfied in default docker environment.
Start docker with this option ```--security-opt seccomp=unconfined``` could resolve this.
Or start the application with no-sandbox option, such as ```code --no-sandbox```.

# rosdep update problem
```rosdep update``` references ```raw.githubusercontent.com``` by hard-coded content.
To avoid unstable connection to github in certain areas, some manual steps have to be taken.
It was described in below link, and also included in the dockerfile of this project.
https://mirrors.ustc.edu.cn/help/rosdistro.html
