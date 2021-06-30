FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apt-utils \
    net-tools \
    mesa-utils \
    gnupg2 \
    wget \
    curl \
    git \
    mc \
    nano \
    cmake \
    gcc \
    cmake-curses-gui \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Timezone Configuration
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ROS install
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt-get update && apt-get install -y ros-melodic-robot ros-melodic-rosconsole
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

# Anaconda installing
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

EXPOSE 11311

RUN conda init

# clone project and install conda env

RUN git clone https://github.com/IvDmNe/point_cloud_processing.git && \
    conda env create -f /point_cloud_processing/scripts/cv_env.yml && \
    echo "conda activate cv" >> ~/.bashrc



# install cv_bridge for python3


RUN apt-get update && apt-get install -y python-catkin-tools python-dev libopencv-dev
RUN mkdir -p /cv_bridge_ws/src && \
    cd /cv_bridge_ws/src && \
    git clone https://github.com/kirillin/vision_opencv.git && \
    cd /cv_bridge_ws && \
    catkin config \
        -DPYTHON_EXECUTABLE=/root/miniconda3/envs/cv/bin/python \
        -DPYTHON_INCLUDE_DIR=/root/miniconda3/envs/cv/include/python3.8 \
        -DPYTHON_LIBRARY=/root/miniconda3/envs/cv/lib/libpython3.8.so \
        -DCMAKE_BUILD_TYPE=Release \
        -DSETUPTOOLS_DEB_LAYOUT=OFF \
        -Drosconsole_DIR=/opt/ros/melodic/share/rosconsole/cmake \
        -Drostime_DIR=/opt/ros/melodic/share/rostime/cmake \
        -Droscpp_traits_DIR=/opt/ros/melodic/share/roscpp_traits/cmake \
        -Dstd_msgs_DIR=/opt/ros/melodic/share/std_msgs/cmake \
        -Droscpp_serialization_DIR=/opt/ros/melodic/share/roscpp_serialization/cmake \
        -Dmessage_runtime_DIR=/opt/ros/melodic/share/message_runtime/cmake \
        -Dgeometry_msgs_DIR=/opt/ros/melodic/share/geometry_msgs/cmake \
        -Dsensor_msgs_DIR=/opt/ros/melodic/share/sensor_msgs/cmake \
        -Dcpp_common_DIR=/opt/ros/melodic/share/cpp_common/cmake && \
    cd src && git clone https://github.com/ros/catkin.git &&  cd .. && \
    catkin config --install && \
    catkin build cv_bridge && \
    echo "source /cv_bridge_ws/install/setup.bash --extend" >> ~/.bashrc



# install PCL library
RUN sudo apt-get install libpcl-dev -y

# RUN pip install --user 'git+https://github.com/facebookresearch/fvcore'
# RUN git clone https://github.com/facebookresearch/detectron2 detectron2_repo
# # set FORCE_CUDA because during `docker build` cuda is not accessible
# ENV FORCE_CUDA="1"
# # This will by default build detectron2 for all common cuda architectures and take a lot more time,
# # because inside `docker build`, there is no way to tell which architecture will be used.
# ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
# ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"

# RUN pip install --user -e detectron2_repo

# RUN detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu111/torch1.8/index.html
  
# RUN pip install detectron2 -f \
#   https://dl.fbaipublicfiles.com/detectron2/wheels/cu111/torch1.8/index.html

WORKDIR /point_cloud_processing/scripts
