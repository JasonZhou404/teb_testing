#!/bin/bash

set -e

current_dir=`pwd -P`
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"

sudo=y

# If user is part of docker group, sudo isn't necessary
if groups $USER | grep &>/dev/null '\bdocker\b'; then
    sudo=n
fi

ros_distro="melodic"
target="${script_dir}/target/"
image_tag="ros-${ros_distro}-docker"
uid=`id -u`
gid=`id -g`
user_name="ros-$USER"

# Build the docker image
echo "Build the docker image... (This can take some time)"
cd "${script_dir}/docker"
if [ "$sudo" = "n" ]; then
    docker build \
        --quiet \
	    --build-arg ros_distro="${ros_distro}" \
        --build-arg uid="${uid}" \
        --build-arg gid="${gid}" \
    	-t ${image_tag} \
    	.
else
    sudo docker build \
        --quiet \
	    --build-arg ros_distro="${ros_distro}" \
        --build-arg uid="${uid}" \
        --build-arg gid="${gid}" \
    	-t ${image_tag} \
    	.
fi

echo "create a new container from this image..."
container_name="${ros_distro}-ros-$USER"
cd "${target}"

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
sudo touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

if [ "$sudo" = "n" ]; then
    docker create \
            --gpus all \
            -e DISPLAY=$DISPLAY \
            --volume=$XSOCK:$XSOCK:rw \
            --volume=$XAUTH:$XAUTH:rw \
            --env="XAUTHORITY=${XAUTH}" \
            -e NVIDIA_VISIBLE_DEVICES=all \
            -e NVIDIA_DRIVER_CAPABILITIES=compute,video,graphics,utility \
            --device=/dev/dri/card0:/dev/dri/card0 \
            -v "${target}/src:/home/${ros_distro}-dev/catkin_ws/src" \
            --name "${container_name}" \
            -it ${image_tag}

    docker ps -aqf "name=${container_name}" > "${target}/docker_id"
else
    sudo docker create \
            --gpus all \
            -e DISPLAY=$DISPLAY \
            --volume=$XSOCK:$XSOCK:rw \
            --volume=$XAUTH:$XAUTH:rw \
            --env="XAUTHORITY=${XAUTH}" \
            -e NVIDIA_VISIBLE_DEVICES=all \
            -e NVIDIA_DRIVER_CAPABILITIES=compute,video,graphics,utility \
            --device=/dev/dri/card0:/dev/dri/card0 \
            -v "${target}/src:/home/${ros_distro}-dev/catkin_ws/src" \
            --name "${container_name}" \
            -it ${image_tag}

    sudo docker ps -aqf "name=${container_name}" > "${target}/docker_id"
fi
chmod 444 "${target}/docker_id"

# That's it!
cd "${current_dir}"

echo
echo "Your dockerized ROS box is now ready in '${target}'."
echo "There you will find:"
echo "    docker_id     This file contains the ROS distribution used in your project."
echo "                  Do not touch this file."
echo "    src           Put your ROS project sources in this directory."
echo "                  It is automatically mounted in ~/catkin_ws/src inside the ROS box."
echo "    go.sh         Run this script to start the container and/or open a shell in it."
echo
echo "Have fun!"
echo
