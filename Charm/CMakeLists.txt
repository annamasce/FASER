cmake_minimum_required(VERSION 3.12)
project(FaserCalDisplay)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find ROOT package
list(APPEND CMAKE_PREFIX_PATH $ENV{ROOTSYS})
find_package(ROOT REQUIRED COMPONENTS GenVector Eve EG Geom Gpad RGL Rint Gui GuiHtml Thread Gdml)

# Include ROOT directories
include(${ROOT_USE_FILE})
include_directories(${ROOT_INCLUDE_DIRS})

add_definitions(-Wno-deprecated-declarations)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake") # (Find*.cmake)
# Find GenFit package
find_package(GenFit REQUIRED)
# Include GenFit headers
include_directories(${GenFit_INCLUDE_DIRS})

# get_filename_component(GenFit_LIBRARY_DIR "${GenFit_LIBRARIES}" DIRECTORY)
# set(GenFit_LIBRARY_DIR "${GenFit_LIBRARY_DIR}" CACHE PATH "Path to GenFit library directory")
# link_directories(${GenFit_LIBRARY_DIR})

# Define the source files
set(SOURCES
    FaserCalDisplay.cxx
    ../CoreUtils/TPOEvent.cc
    ../CoreUtils/TPORecoEvent.cc
    ../CoreUtils/TcalEvent.cc
    ../CoreUtils/TTKTrack.cc
    ../CoreUtils/TPSCluster.cc
    ../CoreUtils/DBScan.cc
    ../CoreUtils/TPSTrack.cc
)

# Generate dictionary
root_generate_dictionary(G__FaserCalDisplay FaserCalDisplay.h LINKDEF disp_linkdef.h)

# Create shared library for FaserCalDisplay
add_library(FaserCalDisplay SHARED ${SOURCES} G__FaserCalDisplay.cxx)
target_include_directories(FaserCalDisplay PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ../CoreUtils ${GenFit_INCLUDE_DIRS})
target_link_libraries(FaserCalDisplay ${ROOT_LIBRARIES} ${GenFit_LIBRARIES})

# Add display app executable
add_executable(FaserCalDisplayApp main.cxx)
target_include_directories(FaserCalDisplayApp PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ../CoreUtils ${GenFit_INCLUDE_DIRS})
target_link_libraries(FaserCalDisplayApp PUBLIC FaserCalDisplay ${ROOT_LIBRARIES} ${GenFit_LIBRARIES})

# Add analyzer executable
add_executable(FaserCalAnalyzer FaserCalAnalyzer.cxx)
target_include_directories(FaserCalAnalyzer PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ../CoreUtils ${GenFit_INCLUDE_DIRS})
target_link_libraries(FaserCalAnalyzer PUBLIC FaserCalDisplay ${ROOT_LIBRARIES} ${GenFit_LIBRARIES})

# Add muonchecker executable
add_executable(DumpMuonHits DumpMuonHits.cxx)
target_include_directories(DumpMuonHits PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ../CoreUtils ${GenFit_INCLUDE_DIRS})
target_link_libraries(DumpMuonHits FaserCalDisplay ${ROOT_LIBRARIES} ${GenFit_LIBRARIES}
)

# Add EventList executable
add_executable(DumpEventList DumpEventList.cxx)
target_include_directories(DumpEventList PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ../CoreUtils ${GenFit_INCLUDE_DIRS})
target_link_libraries(DumpEventList FaserCalDisplay ${ROOT_LIBRARIES} ${GenFit_LIBRARIES})

# Add RPATH for runtime library discovery
set(CMAKE_INSTALL_RPATH "${ROOT_LIBRARY_DIR};${GenFit_LIBRARIES};$ENV{ROOTSYS}/lib")
set(CMAKE_BUILD_RPATH "${ROOT_LIBRARY_DIR};${GenFit_LIBRARIES};$ENV{ROOTSYS}/lib")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# Debug output
message(STATUS "ROOT Library Directory: ${ROOT_LIBRARY_DIR}")
message(STATUS "GenFit Library: ${GenFit_LIBRARIES}")
