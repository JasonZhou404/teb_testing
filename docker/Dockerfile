ARG ros_distro
ARG uid
ARG gid
FROM osrf/ros:${ros_distro}-desktop-full

ARG ros_distro
ARG uid
ARG gid

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --force-yes install \
		sudo \
		python-catkin-tools \
		dialog \
		less \
		x-window-system \
		mesa-utils

# install teb related packages
RUN apt-get install -y ros-${ros_distro}-teb-local-planner
RUN apt-get install -y ros-${ros_distro}-stage-ros

# install other packages
RUN apt-get install -y vim
RUN apt-get install -y python-tk

RUN mkdir -p /home/${ros_distro}-dev/catkin_ws/src && \
    echo "${ros_distro}-dev:x:${uid}:${gid}:Developer,,,:/home/${ros_distro}-dev:/bin/bash" >> /etc/passwd && \
    echo "${ros_distro}-dev:x:${gid}:" >> /etc/group && \
    echo "${ros_distro}-dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${ros_distro}-dev && \
    chmod 0440 /etc/sudoers.d/${ros_distro}-dev && \
    chown ${uid}:${gid} -R /home/${ros_distro}-dev

USER ${ros_distro}-dev
ENV HOME /home/${ros_distro}-dev

COPY bashrc /home/${ros_distro}-dev/.bashrc
COPY bashrc /root/.bashrc
COPY bash_profile /home/${ros_distro}-dev/.bash_profile
COPY bash_profile /root/.bash_profile

COPY rosbox_entrypoint.sh /rosbox_entrypoint.sh
ENTRYPOINT /rosbox_entrypoint.sh

# nvidia hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# set environment variables
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
