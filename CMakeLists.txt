cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

project(Kinfu)
#find_package(Boost REQUIRED COMPONENTS )
#find_package(PCL REQUIRED COMPONENTS common io KDTree visualization GPU)
find_package(PCL REQUIRED)

find_package(OpenCV REQUIRED)
#find_package(Eigen REQUIRED)

option(USE_COCL "Use Cuda On CL instead of cuda (UNTESTED)" OFF)

if(USE_COCL)
	include($ENV{HOME}/coriander/share/cocl/cocl.cmake)
  ENABLE_CUDA_FUDGE()
else()
	find_package(CUDA REQUIRED)
endif()

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin )

include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CUDA_TOOLKIT_INCLUDE})

add_definitions(-DHAVE_OPENCV)

include_directories(${PCL_INCLUDE_DIRS})

#Cuda hacks for a modern compiler. IE, tell it to use a old compiler.
set(CUDA_HOST_COMPILER "/usr/bin/gcc-5")
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} "-ccbin /usr/bin/gcc-5") 

#Taken from CMakeLists in PCL
if (UNIX OR APPLE)
  set (CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}  "-Xcompiler;-fPIC;")
endif()

if(NOT UNIX OR APPLE)
	add_definitions(-DPCLAPI_EXPORTS)
endif()

FILE(GLOB cuda src/cuda/*.cu src/cuda/*.h*)

set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} "--ftz=true;--prec-div=false;--prec-sqrt=false")		
CUDA_COMPILE(cuda_objs ${cuda})

#End PCL taken code.

#message("${cuda_objs}")

string(REPLACE ${PCL_GPU_KINFU_LARGE_SCALE_LIBRARY} "" PCL_NOKINFU "${PCL_LIBRARIES}")
string(REPLACE ${PCL_GPU_KINFU_LIBRARY} "" PCL_NOKINFU2 "${PCL_NOKINFU}")

file(GLOB KinfuLibSrc
    "src/*.cpp"
)
add_library (KinfuLib SHARED ${KinfuLibSrc} ${cuda_objs})
target_link_libraries(KinfuLib ${PCL_NOKINFU2} ${OpenCV_LIBS} ${CUDA_LIBRARIES})


add_executable (KinfuLS tools/kinfuLS_app.cpp tools/evaluation.cpp tools/capture.cpp )
target_link_libraries (KinfuLS KinfuLib ${PCL_NOKINFU2} ${OpenCV_LIBS} )

add_executable (KinfuLS_meshOut tools/process_kinfu_large_scale_output.cpp)
target_link_libraries (KinfuLS_meshOut KinfuLib ${PCL_NOKINFU2} ${OpenCV_LIBS} )

