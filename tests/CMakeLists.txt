cmake_minimum_required(VERSION 3.15)
project(test)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

include(FindPkgConfig)
find_package(Rave HINTS /Users/annamascellani/workspace/faser/FASER/rave-install REQUIRED)
find_package(Boost REQUIRED)

add_executable(test main.cpp)
target_link_libraries(test Rave Boost)

message(STATUS "Building against Rave includes: ${Rave_INCLUDE_DIRS}")
message(STATUS "Building against Rave libraries: ${Rave_LIBRARIES}")
target_include_directories(test PRIVATE ${Rave_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

target_compile_options(test PRIVATE -I/Users/annamascellani/workspace/faser/FASER/rave-install/include -I/Users/annamascellani/workspace/faser/FASER/rave-install/include/rave/swig -DRAVE -DRaveDllExport= -DWITH_FLAVORTAGGING -DWITH_KINEMATICS -L/Users/annamascellani/workspace/faser/FASER/rave-install/lib -lRaveBase -lRaveCore -lRaveVertex -lRaveFlavorTag -lRaveVertexKinematics)