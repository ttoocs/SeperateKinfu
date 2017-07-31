cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

project(Kinfu)
#find_package(Boost REQUIRED COMPONENTS )
#find_package(PCL REQUIRED COMPONENTS common io KDTree visualization GPU)
find_package(PCL REQUIRED)
find_package(CUDA QUIET REQUIRED)
find_package(OpenCV REQUIRED)
#find_package(Eigen REQUIRED)

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/bin )

include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CUDA_TOOLKIT_INCLUDE})

add_definitions(-DHAVE_OPENCV)

include_directories(${PCL_INCLUDE_DIRS})
include_directories(${PCL_GPU_CONTAINERS_INCLUDE_DIR})
#link_directories(${PCL_LIBRARY_DIRS})
#add_definitions(${PCL_DEFINITIONS}) 

#CUDA_ADD_LIBRARY(cudashit SHARED
#  src/cuda/
#)
add_executable (Kinfu tools/kinfuLS_app.cpp tools/evaluation.cpp)
#target_link_libraries (Kinfu ${PCL_LIBRARIES} ${OpenCV_LIBS})
#target_link_libraries (Kinfu ${OpenCV_LIBS})
  #Link each part of PCL-seperetly?
