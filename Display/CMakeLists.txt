cmake_minimum_required(VERSION 3.12)
project(FaserCalDisplay)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find ROOT package
list(APPEND CMAKE_PREFIX_PATH $ENV{ROOTSYS})
find_package(ROOT REQUIRED COMPONENTS Eve EG Geom Gpad RGL Rint Gui GuiHtml Thread Gdml)

# Include ROOT directories
include(${ROOT_USE_FILE})
include_directories(${ROOT_INCLUDE_DIRS})

add_definitions(-Wno-deprecated-declarations)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake") # (Find*.cmake)

# Find libraries
find_package(GenFit REQUIRED)

# # Include PandoraPAF headers
# include_directories(/data/sw/products/PandoraPFA/install/include)
# ##include_directories(/data/sw/products/PandoraPFA/install/include/Api)
# link_directories(/data/sw/products/PandoraPFA/install/lib)
# find_library(PANDORA_SDK_LIB PandoraSDK PATHS /data/sw/products/PandoraPFA/install/lib)
# find_library(PANDORA_MON_LIB PandoraMonitoring PATHS /data/sw/products/PandoraPFA/install/lib)
# if (NOT PANDORA_SDK_LIB)
#     message(FATAL_ERROR "PandoraSDK library not found!")
# endif()

# if (NOT PANDORA_MON_LIB)
#     message(WARNING "PandoraMonitoring library not found! Proceeding without it.")
# endif()

# # Find FastJet
# set(FASTJET_DIR /data/sw/products/fastjet-install)

# find_path(FASTJET_INCLUDE_DIRS fastjet/ClusterSequence.hh PATHS ${FASTJET_DIR}/include)
# find_library(FASTJET_LIB fastjet PATHS ${FASTJET_DIR}/lib)

# if (NOT FASTJET_INCLUDE_DIRS OR NOT FASTJET_LIB)
#     message(FATAL_ERROR "FastJet library not found! Install FastJet and set the correct paths.")
# endif()

# # Include FastJet headers
# include_directories(${FASTJET_INCLUDE_DIRS})
# link_directories(${FASTJET_DIR}/lib)

# Include GenFit directories
# set(GENFITINCDIR /data/sw/FASERCAL/FASER/GenFit-install/include)
# include_directories(${GENFITINCDIR})
# set(GENFITLIBDIR /data/sw/FASERCAL/FASER/GenFit-install/lib)
# link_directories(${GENFITLIBDIR})

include_directories(${GenFit_INCLUDE_DIRS})
link_directories(${GenFit_LIBRARIES})

# Define the source files
set(SOURCES
    FaserCalDisplay.cxx
    main.cxx
    ../CoreUtils/TPOEvent.cc
    ../CoreUtils/TPORecoEvent.cc
    ../CoreUtils/TcalEvent.cc
    ../CoreUtils/TTKTrack.cc
    ../CoreUtils/TPSCluster.cc
    ../CoreUtils/DBScan.cc
    ../CoreUtils/TPSTrack.cc
    #../CoreUtils/PandoraInterface.cc
    #../CoreUtils/FASERCalParticleFlowObjects.cc
    #../CoreUtils/FASERCalTrackAlgorithm.cc
    #../CoreUtils/FASERCalPandora.cc
)

# Generate dictionary
root_generate_dictionary(G__FaserCalDisplay FaserCalDisplay.h LINKDEF disp_linkdef.h)

# Create shared library for FaserCalDisplay
add_library(FaserCalDisplay SHARED FaserCalDisplay.cxx G__FaserCalDisplay.cxx)

# Add executable
#add_executable(FaserCalDisplay ${SOURCES} G__FaserCalDisplay.cxx)

add_executable(FaserCalDisplayApp ${SOURCES})

# Include directories
target_include_directories(FaserCalDisplay PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ${CoreUtils_INCLUDE_DIRS} ${GenFit_INCLUDE_DIRS})
target_include_directories(FaserCalDisplayApp PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} ../CoreUtils ${GenFit_INCLUDE_DIRS})

# target_link_libraries(FaserCalDisplay ${ROOT_LIBRARIES} ${GENFIT_LIB})
# target_link_libraries(FaserCalDisplayApp FaserCalDisplay stdc++fs ${ROOT_LIBRARIES} ${GENFIT_LIB} ${PANDORA_SDK_LIB} ${PANDORA_MON_LIB} ${FASTJET_LIB})
target_link_libraries(FaserCalDisplayApp PUBLIC FaserCalDisplay stdc++fs ${ROOT_LIBRARIES} ${GenFit_LIBRARIES})

# Add RPATH for runtime library discovery
set(CMAKE_INSTALL_RPATH "${ROOT_LIBRARY_DIR};${GenFit_LIBRARIES};$ENV{ROOTSYS}/lib")
set(CMAKE_BUILD_RPATH "${ROOT_LIBRARY_DIR};${GenFit_LIBRARIES};$ENV{ROOTSYS}/lib")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_INSTALL_RPATH "${ROOT_LIBRARY_DIR};${GenFit_LIBRARIES};/data/sw/products/PandoraPFA/install/lib")
set(CMAKE_BUILD_RPATH "${ROOT_LIBRARY_DIR};${GenFit_LIBRARIES};/data/sw/products/PandoraPFA/install/lib")


# Debug output
message(STATUS "ROOT Library Directory: ${ROOT_LIBRARY_DIR}")
# message(STATUS "GenFit Library Directory: ${GenFit_INCLUDE_DIRS}")
message(STATUS "GenFit Library: ${GenFit_LIBRARIES}")
