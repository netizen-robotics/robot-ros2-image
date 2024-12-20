ARG ROS2_DISTRO=jazzy

FROM ros:$ROS2_DISTRO-perception
ARG ROS2_DISTRO

ENV ROS2_DISTRO=$ROS2_DISTRO
 
RUN apt-get update

# Install navigation and slam packages
RUN apt-get install ros-${ROS2_DISTRO}-navigation2 ros-${ROS2_DISTRO}-nav2-bringup ros-${ROS2_DISTRO}-slam-toolbox -y

# Setup build tools and libraries
RUN apt-get install python3-colcon-common-extensions -y

# Create a custom user
RUN groupadd -g 1001 netizen_robotics && \
    useradd -m -u 8000 -g netizen_robotics user
  
# Setup entrypoint
COPY --chown=user:netizen_robotics ./script/entrypoint.sh  /home/user/entrypoint.sh
RUN chmod +x /home/user/entrypoint.sh

# Switch to the custom user
USER user

# Create a workspace
RUN mkdir -p /home/user/robot_ws/src

# Set the workdir
WORKDIR /home/user
ENTRYPOINT ["/home/user/entrypoint.sh"]