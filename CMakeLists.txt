cmake_minimum_required(VERSION 3.0.2)
project(grasping_vision)

## Compile as C++11, supported in ROS Kinetic and newer
add_compile_options(-std=c++14)


find_package(catkin REQUIRED COMPONENTS
  roscpp
  pcl_ros
  pcl_conversions
  std_msgs
  the_mainest
  # cv_bridge
  # image_transport
)

# find_package(OpenCV REQUIRED)
find_package(PCL REQUIRED)
find_package(Eigen3 REQUIRED NO_MODULE)



catkin_package(
 INCLUDE_DIRS
 LIBRARIES
 CATKIN_DEPENDS roscpp std_msgs the_mainest
#  DEPENDS the_mainest
)

include_directories(
  # include
  ${catkin_INCLUDE_DIRS}
  # ${OpenCV_INCLUDE_DIRS}

)

add_executable(get_obb src/get_obb.cpp)
add_executable(plane_segment src/plane_segment.cpp)
add_executable(visualize_obb src/visualize_obb.cpp)

target_link_libraries(get_obb
  ${catkin_LIBRARIES}
  ${PCL_LIBRARIES}
  ${EIGEN_LIBRARIES}
  # ${OpenCV_LIBS}
)
add_dependencies(get_obb ${catkin_EXPORTED_TARGETS})


target_link_libraries(plane_segment
  ${catkin_LIBRARIES}
  ${PCL_LIBRARIES}
  ${EIGEN_LIBRARIES}
  # ${OpenCV_LIBS}
)
add_dependencies(plane_segment ${catkin_EXPORTED_TARGETS})



target_link_libraries(visualize_obb
  ${catkin_LIBRARIES}
  ${PCL_LIBRARIES}
  ${EIGEN_LIBRARIES}
  # ${OpenCV_LIBS}
)
add_dependencies(visualize_obb ${catkin_EXPORTED_TARGETS})

