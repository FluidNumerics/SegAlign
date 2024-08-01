#
#
# When building on systems with only CUDA installed
#
#   > Set the target architecture in the CMake step using the CMAKE_CUDA_ARCHITECTURES
#     variable. For example
#
#     ```
#       mkdir build && cd build/
#       cmake -DCMAKE_CUDA_ARCHITECTURES=70 ../
#       make && make install 
#     ```
#
#   > 
cmake_minimum_required (VERSION 3.21)

project(segalign LANGUAGES CXX)


# Check for HIP
find_package(hip)
if(hip_FOUND)
    find_package(rocprim REQUIRED)
    find_package(rocthrust REQUIRED)
    find_package(hipcub REQUIRED)
    enable_language(HIP)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DHIP_ENABLED")
    set(CMAKE_HIP_FLAGS "${CMAKE_HIP_FLAGS} -DHIP_ENABLED")
else()
    # If HIP is not found, then we enable the CUDA language
    # and check for the CUDA package
    enable_language(CUDA)
    find_package(CUDA 9.0 REQUIRED)
endif()

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O4 -std=c++11 -l c")

# Dependencies
find_package(TBB REQUIRED tbb tbbmalloc tbbmalloc_proxy)
set(TBB_INLCUDE_DIRS "${TBB_ROOT}/include")
set(TBB_LIBRARIES TBB::tbb TBB::tbbmalloc TBB::tbbmalloc_proxy)
include_directories(${TBB_INCLUDE_DIRS})

find_package(ZLIB REQUIRED)
find_path(ZLIB_INCLUDE_DIR zlib.h)
include_directories(${ZLIB_INCLUDE_DIR})

find_package(Boost COMPONENTS program_options REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})
# End dependencies

if(hip_FOUND)
  set(DEP_LIBS ${TBB_LIBRARIES} ${Boost_LIBRARIES} ${ZLIB_LIBRARIES})
  set(DEP_INCLUDES ${TBB_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIRS})
else()
  set(DEP_LIBS rt stdc++ ${TBB_LIBRARIES} ${Boost_LIBRARIES} ${CUDA_LIBRARIES} ${ZLIB_LIBRARIES})
  set(DEP_INCLUDES ${TBB_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS} ${CUDA_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIRS})
endif()

get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
add_subdirectory(${CMAKE_SOURCE_DIR}/src)
add_subdirectory(${CMAKE_SOURCE_DIR}/repeat_masker_src)