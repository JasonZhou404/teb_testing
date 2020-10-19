# Introduction
This repo is a docker env for testing Timed Elastic Band local planning following the tutorial on http://wiki.ros.org/teb_local_planner/Tutorials

# Credits

Work done by JasonZhou404@https://github.com/JasonZhou404

This project is inspired by git@github.com:pierrekilly/docker-ros-box.git, and adapted by nvidia-docker support and specific docker image setup required by git@github.com:rst-tu-dortmund/teb_local_planner_tutorials.git

# Usage

under `teb-testing`:

1. Initialize your ROS box:

sudo ./init-ros-box.sh

2. Connect to your ROS box

./target/go.sh

# Testing Procedures

1. run "catkin_make" in "/home/melodic-dev/catkin_ws" to build up teb_local_planner_tutorials

2. run "source /home/melodic-dev/catkin_ws/devel/setup.bash"

3. run "roscore"

4. Probably set "rosparam set /test_optim_node/enable_homotopy_class_planning False" if you ran into rviz corruption

5. follow the http://wiki.ros.org/teb_local_planner/Tutorials or do whatever you want 
