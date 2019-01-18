#/*============================================================================
#
#  MYPROJECT: A software package for whatever.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#============================================================================*/

######################################################################
# Set the minimum CMake version.
######################################################################
set(MYPROJECT_CMAKE_MINIMUM_REQUIRED_VERSION 3.5)
cmake_minimum_required(VERSION ${MYPROJECT_CMAKE_MINIMUM_REQUIRED_VERSION})


###################################################################################
# Set some CMake Policies.
# See http://cmake.org/cmake/help/cmake-2-8-docs.html#section_Policies for details.
###################################################################################
set(project_policies )
foreach(policy ${project_policies})
  if(POLICY ${policy})
    cmake_policy(SET ${policy} NEW)
  endif()
endforeach()


###############################################################################
# Setup project name, and version. Version number gets baked into package name.
###############################################################################
if (BUILD_SUPERBUILD)
  project(MyProject-superbuild)
  set(MYPROJECT_SOURCE_DIR ${PROJECT_SOURCE_DIR})
  set(MYPROJECT_BINARY_DIR ${PROJECT_BINARY_DIR})
else()
  project(MyProject VERSION 0.0.1)
endif()


######################################################################
# Setup the path to load CMake macros, and extra CMake files.
# This means cmake can 'see' or 'use' files in the CMake folder.
######################################################################
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake)


######################################################################
# Include extra CMake stuff for configuring this project.
######################################################################
include(mitkMacroEmptyExternalProject)
include(mitkFunctionCheckCompilerFlags)
include(mitkFunctionGetGccVersion)
include(mpMacroInstallCommandLineApp)
include(mpMacroInstallHeaders)
include(mpMacroInstallLibrary)
include(mpMacroCreateGuiApplication)


######################################################################
# Set main build options.
######################################################################
option(BUILD_TESTING "Build Unit tests." ON)
option(BUILD_SHARED_LIBS "Build Shared Libraries" OFF)
option(BUILD_SUPERBUILD "Build MYPROJECT and the projects it depends on via SuperBuild.cmake." ON)
option(MYPROJECT_USE_OPENMP "Use OpenMP." OFF)
option(MYPROJECT_USE_CUDA "Use CUDA." OFF)
option(MYPROJECT_DELAYLOAD_CUDA "(Windows only) If enabled the CUDA DLLs will be a soft delay-load dependency and MYPROJECT can run without them." OFF)
mark_as_advanced(MYPROJECT_DELAYLOAD_CUDA)
set(MYPROJECT_CUDA_ARCH_BIN "" CACHE STRING "CUDA compute capability to build for - user must specify it.") # See: https://en.wikipedia.org/wiki/CUDA
option(MYPROJECT_USE_MPI "Use MPI." OFF)


######################################################################
# Setup Testing (dashboards etc.).
######################################################################
include(mpSetupTesting)


######################################################################
# Define variables that we carry through to sub-directories.
######################################################################
set(_known_apps "")             # Temp variable.
set(MYPROJECT_BOOST_LIBS "")    # List of required Boost libraries.
set(QT5_LINK_LIBRARIES)         # List of required Qt libraries.
set(BUILDING_GUIS OFF)          # Whether or not any GUI projects are on.
set(ALL_THIRD_PARTY_LIBRARIES)  # List of all 3rd party libraries to link to.
set(ADDITIONAL_SEARCH_PATHS "") # List of all folders to search for .dlls when packaging, and setting up Visual Studio paths.
if(WIN32)
  list(APPEND ADDITIONAL_SEARCH_PATHS "${CMAKE_BINARY_DIR}/bin/${VS_BUILD_TYPE}")
endif()


#######################################################################
# Add some third party packages. Note: Ordering is very important.
# Also, if you don't want one, you can just search for the package name
# (e.g. VTK) in this file, and remove all those lines you don't want.
#######################################################################
include(mpAddgflags)
include(mpAddglog)
include(mpAddEigen)
include(mpAddFLANN)
include(mpAddVTK)
include(mpAddOpenCV)
include(mpAddBoost)
include(mpAddPythonBindings)
include(mpAddPCL)
include(mpAddUnityWrapper)


######################################################################
# Add our Gui projects. If you don't want Gui stuff, remove this line.
######################################################################
include(mpAddGuiProjects)


######################################################################
# Make sure at this point in this file, VTK is the correct version.
######################################################################
include(mpSetupVTKBackend)


##############################################################################
# Further variables for the external project names and locations are defined
# in the external project CMake files under CMake/ExternalProjects.
##############################################################################
set(NIFTK_EP_TARBALL_LOCATION "http://cmic.cs.ucl.ac.uk/platform/dependencies")


######################################################################
# MYPROJECT uses KWStyle for checking the coding style.
######################################################################
include(${CMAKE_SOURCE_DIR}/Utilities/KWStyle/MYPROJECTKWStyle.cmake)


######################################################################
# MYPROJECT uses CppCheck for static analysis.
######################################################################
include(${CMAKE_SOURCE_DIR}/Utilities/CppCheck/MYPROJECTCppCheck.cmake)


######################################################################
# MYPROJECT uses Doxygen for documentation generation.
######################################################################
include(mpAddDocs)


######################################################################
# Setting supported build types. Should ONLY be Release or Debug.
######################################################################
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Valid options are Release or Debug" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Release" "Debug")
endif()

if (NOT (CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "Debug"))
  message(FATAL_ERROR "Build type \"${CMAKE_BUILD_TYPE}\" is not supported.")
endif()

if(WIN32)
  # Restrict the generated configuration to be what we configured above.
  # No point creating project files for build types that will not compile.
  # Note: it's set to FORCE so that both CMAKE_BUILD_TYPE and CMAKE_CONFIGURATION_TYPES match up.
  set(CMAKE_CONFIGURATION_TYPES ${CMAKE_BUILD_TYPE} CACHE STRING "Build configurations to generate." FORCE)
  mark_as_advanced(CMAKE_CONFIGURATION_TYPES)
endif()


######################################################################
# Check for Qt early, as VTK may need it in SuperBuild.
######################################################################
include(mpIncludeQt)


######################################################################
# Choose C++ standard. Currently 11, as we try to support VS2013.
######################################################################
set(MYPROJECT_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS 0)
set(CMAKE_CXX_STANDARD ${MYPROJECT_CXX_STANDARD})
set(CMAKE_CXX_STANDARD_REQUIRED 1)

if(CMAKE_COMPILER_IS_GNUCXX)
  mitkFunctionGetGccVersion(${CMAKE_CXX_COMPILER} GCC_VERSION)
else()
  set(GCC_VERSION 0)
endif()

# This is necessary to avoid problems with compile feature checks.
# CMAKE_CXX_STANDARD seems to only set the -std=c++11 flag for targets.
# However, compile flag checks also need to be done with -std=c++11.
# The MYPROJECT_CXX11_FLAG variable is also used for external projects
# build during the MYPROJECT super-build.
mitkFunctionCheckCompilerFlags("-std=c++11" MYPROJECT_CXX11_FLAG)
if(NOT MYPROJECT_CXX11_FLAG)
  # Older gcc compilers use -std=c++0x
  mitkFunctionCheckCompilerFlags("-std=c++0x" MYPROJECT_CXX11_FLAG)
endif()


######################################################################
# Force MSVC runtime. Depends on BUILD_SHARED_LIBS.
######################################################################
include(mpSetupMSVCRuntime)


######################################################################
# Try finding CUDA before SuperBuild, so that hopefully these vars
# are more likely to be set consistently throughought all dependencies.
######################################################################
include(mpIncludeCUDA)


######################################################################
# Make sure Git is available, as SuperBuild may need to do updates.
######################################################################
find_package(Git REQUIRED)
if (WIN32)
  set(GITCOMMAND ${GIT_EXECUTABLE})
endif()


######################################################################
# Now, if required, do the SuperBuild
# If we are doing SuperBuild
#   We configure up to this point (see the return() statement below)
#   and then we call SuperBuild.cmake, which builds all the
#   dependencies as CMake ExternalProjects, and then also builds
#   MYPROJECT as an ExternalProject. However instead of downloading
#   a tar file, you set the SOURCE_DIR to be THIS project, and force
#   the BUILD_SUPERBUILD flag to be off (to avoid infinite loop).
#
# If we are NOT doing superbuild, then the next statement has no
# effect, and the build goes on the same as before.
######################################################################
if(BUILD_SUPERBUILD)
  include("CMake/SuperBuild.cmake")
  return()
endif(BUILD_SUPERBUILD)


######################################################################
# End of SuperBuild. Print out where the source and binary folders
# are, just to make it really explicit... well, explicit to the user
# that bothers to read these messages! :-)
######################################################################
message("CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}")
message("CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR}")


######################################################################
# Additionally add the build folder, now we are building main project.
######################################################################
list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})


######################################################################
# Copy some reference files to output.
######################################################################
configure_file(${CMAKE_SOURCE_DIR}/Documentation/License.dox ${CMAKE_BINARY_DIR}/Doxygen/License.dox)
configure_file(${CMAKE_SOURCE_DIR}/LICENSE.txt ${CMAKE_BINARY_DIR}/LICENSE.txt @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/LICENSE.txt DESTINATION . COMPONENT CONFIG)
configure_file(${CMAKE_SOURCE_DIR}/README.md ${CMAKE_BINARY_DIR}/README.md @ONLY)
configure_file(${CMAKE_SOURCE_DIR}/README.txt ${CMAKE_BINARY_DIR}/README.txt @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/README.txt DESTINATION . COMPONENT CONFIG)
configure_file(${CMAKE_SOURCE_DIR}/INSTALLATION.txt ${CMAKE_BINARY_DIR}/INSTALLATION.txt @ONLY)
configure_file(${CMAKE_SOURCE_DIR}/MyProjectConfigure.h.in ${CMAKE_BINARY_DIR}/MyProjectConfigure.h @ONLY)


######################################################################
# Organise module/plugin/etc projects better within the IDE.
######################################################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON)


######################################################################
# Add Optional Requirements
######################################################################
if(WIN32)
  set(_library_sub_dir "bin")
else()
  set(_library_sub_dir "lib")
endif()

# These are dependent on ordering
include(mpIncludegflags)
include(mpIncludeglog)
include(mpIncludeEigen)
include(mpIncludeBoost)
include(mpIncludePythonBindings)
include(mpIncludeOpenCV)
include(mpIncludeVTK)
include(mpIncludePCL)


######################################################################
# This must come after all the external packages that need
# their documentation bundling in with this packages documentation.
######################################################################
include(mpIncludeDocs)


######################################################################
# Compilation specific stuff, like flags etc.
######################################################################
if(WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DNOMINMAX /W2")
  set(CMAKE_CXX_WARNING_LEVEL 2)
endif(WIN32)

if(WIN32 AND NOT BUILD_SHARED_LIBS)
  add_definitions(-DMYPROJECT_STATIC)
endif()

include(mpIncludeOpenMP)
include(mpIncludeMPI)


######################################################################
# A few shortcuts for lists of libraries.
######################################################################
set(MYPROJECT_LIBRARIES myproject)
set(ALL_LIBRARIES ${MYPROJECT_LIBRARIES} ${ALL_THIRD_PARTY_LIBRARIES} ${QT5_LINK_LIBRARIES})


######################################################################
# Set up a few paths.
######################################################################
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(MYPROJECT_INSTALL_LIB_DIR lib)
set(MYPROJECT_INSTALL_INC_DIR include)
set(MYPROJECT_INSTALL_BIN_DIR bin)

foreach(type LIBRARY RUNTIME ARCHIVE)
  if(NOT MYPROJECT_PYTHON_OUTPUT_DIRECTORY STREQUAL "" AND ${type} STREQUAL "LIBRARY")
    set(CMAKE_${type}_OUTPUT_DIRECTORY ${MYPROJECT_PYTHON_OUTPUT_DIRECTORY} CACHE INTERNAL "Output dir for Python module.")
  else()
    set(CMAKE_${type}_OUTPUT_DIRECTORY ${EXECUTABLE_OUTPUT_PATH} CACHE INTERNAL "Single output directory for building all libraries.")
  endif()
  mark_as_advanced(CMAKE_${type}_OUTPUT_DIRECTORY)
endforeach()

include_directories(${CMAKE_SOURCE_DIR}/Code/Lib)
include_directories(${CMAKE_BINARY_DIR})


######################################################################
# Add our main code folders. This is where all our functionality is.
######################################################################
add_subdirectory(Code)
add_subdirectory(Documentation)
if(BUILD_TESTING)
  set(TEMP_DIR ${CMAKE_BINARY_DIR}/Testing/Temporary)
  include_directories(${CMAKE_SOURCE_DIR}/Testing/)
  add_subdirectory(Testing)
endif()


###############################################################################################
# The next call generates CMake code to enable external projects to correctly use MYPROJECT.
###############################################################################################
include(mpSetupExternalConfig)


######################################################################
# Packaging code. Read the README.md.
######################################################################
include(mpSetupPackaging)


######################################################################
# If we are under Windows, create batch files which correctly
# set up the environment for Visual Studio. These are only used to
# start VS when developing. Not used in the final installation package.
######################################################################
include(mpSetupVisualStudioPaths)
