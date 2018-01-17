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


##################################################################################
# Set some CMake Policies.
# See http://cmake.org/cmake/help/cmake-2-8-docs.html#section_Policies for details
##################################################################################
set(project_policies )
foreach(policy ${project_policies})
  if(POLICY ${policy})
    cmake_policy(SET ${policy} NEW)
  endif()
endforeach()


##############################################################################
# Setup project name, and version.
##############################################################################
if (BUILD_SUPERBUILD)
  project(MYPROJECT-superbuild)
  set(MYPROJECT_SOURCE_DIR ${PROJECT_SOURCE_DIR})
  set(MYPROJECT_BINARY_DIR ${PROJECT_BINARY_DIR})
else()
  project(MYPROJECT VERSION 0.0.0)
endif()


######################################################################
# Setup the path to load CMake macros, and extra CMake files.
######################################################################
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake)
include(mitkMacroEmptyExternalProject)
include(mitkFunctionCheckCompilerFlags)
include(mpMacroInstallCommandLineApp)
include(mpMacroInstallHeaders)
include(mpMacroInstallLibrary)
include(mpCreateGuiApplication)


######################################################################
# Set main build options.
######################################################################
option(BUILD_TESTING "Build Unit tests." ON)
option(BUILD_SHARED_LIBS "Build Shared Libraries" OFF)
option(BUILD_SUPERBUILD "Build MYPROJECT and the projects it depends on via SuperBuild.cmake." ON)
option(MYPROJECT_USE_OPENMP "Use OpenMP." OFF)
option(MYPROJECT_USE_CUDA "Use CUDA." OFF)
option(MYPROJECT_DELAYLOAD_CUDA "(Windows only) If enabled the CUDA DLLs will be a soft delay-load dependency and NifTK can run without them." OFF)
mark_as_advanced(MYPROJECT_DELAYLOAD_CUDA)
set(MYPROJECT_CUDA_ARCH_BIN "" CACHE STRING "CUDA compute capability to build for.") # See: https://en.wikipedia.org/wiki/CUDA
option(MYPROJECT_USE_MPI "Use MPI." OFF)


######################################################################
# Setup Testing (dashboards etc.)
######################################################################
include(mpSetupTesting)


######################################################################
# Add some third party packages. Note: Ordering is important.
######################################################################
include(mpAddgflags)
include(mpAddglog)
include(mpAddEigen)
include(mpAddFLANN)
include(mpAddVTK)
include(mpAddOpenCV)
include(mpAddBoost)
include(mpAddPythonBindings)

option(BUILD_PCL "Build PCL." OFF)
if(BUILD_PCL)
  find_package(OpenGL REQUIRED)
  option(BUILD_PCL_VIS "Build PCL Visualisation tools." OFF)
endif()

option(BUILD_QTVTKGUI "Build QtVTK Gui." OFF)
option(BUILD_QMLDEMO "Build QMLDemo Gui" OFF)

if(BUILD_PYTHON_BINDINGS AND BUILD_QTVTKGUI)
  set(BUILD_QTVTKGUI OFF CACHE BOOL "Build QtVTK Gui." FORCE)
  message("Forcing BUILD_QTVTKGUI to OFF as you want a python module.")
endif()

if(BUILD_PYTHON_BINDINGS AND BUILD_QMLDEMO)
  set(BUILD_QMLDEMO OFF CACHE BOOL "Build QMLDemo Gui." FORCE)
  message("Forcing BUILD_QMLDEMO to OFF as you want a python module.")
endif()

if(BUILD_PYTHON_BINDINGS AND BUILD_SHARED_LIBS)
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build Shared Libraries" FORCE)
  message("Forcing BUILD_SHARED_LIBS to OFF as you want a python module.")
endif()

option(MYPROJECT_USE_QT "Use Qt." OFF)
mark_as_advanced(MYPROJECT_USE_QT) # Qt gets baked into VTK, so really developers should not fiddle with this.

if(BUILD_PCL AND NOT BUILD_Boost)
  set(BUILD_Boost ON CACHE BOOL "Build Boost." FORCE)
  message("Forcing BUILD_Boost to ON due to BUILD_PCL being ON.")
endif()

if(BUILD_PCL AND NOT BUILD_Eigen)
  set(BUILD_Eigen ON CACHE BOOL "Build Eigen." FORCE)
  message("Forcing BUILD_Eigen to ON due to BUILD_PCL being ON.")
endif()

if(BUILD_PCL AND NOT BUILD_FLANN)
  set(BUILD_FLANN ON CACHE BOOL "Build FLANN." FORCE)
  message("Forcing BUILD_FLANN to ON due to BUILD_PCL being ON.")
endif()

if(BUILD_PCL_VIS AND NOT BUILD_PCL)
  set(BUILD_PCL_VIS ON CACHE BOOL "Build PCL Visualisation tools." FORCE)
  message("Forcing BUILD_PCL_VIS to OFF due to BUILD_PCL being OFF.")
endif()

if(BUILD_QTVTKGUI AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QTVTKGUI being ON.")
endif()

if(BUILD_QTVTKGUI AND NOT BUILD_VTK)
  set(BUILD_VTK ON CACHE BOOL "Build VTK." FORCE)
  message("Forcing BUILD_VTK to ON due to BUILD_QTVTKGUI being ON.")
endif()

if(BUILD_QMLDEMO AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QMLDEMO being ON.")
endif()

if(BUILD_QMLDEMO AND NOT BUILD_SHARED_LIBS)
  message("Forcing BUILD_SHARED_LIBS to ON due to BUILD_QMLDEMO being ON.")
  set(BUILD_SHARED_LIBS ON CACHE BOOL "Build Shared Libraries" FORCE)
endif()

# due to https://github.com/PointCloudLibrary/pcl/issues/712
if(APPLE AND BUILD_PCL AND BUILD_PCL_VIS AND "${VTK_VERSION}" STREQUAL "${DEFAULT_VTK_VERSION}")
  set(VTK_VERSION "${FALLBACK_VTK_VERSION}")
  message("Forcing VTK_VERSION to ${VTK_VERSION} as you are on Mac OSX and both BUILD_PCL and BUILD_PCL_VIS are on.")
endif()
if("${VTK_VERSION}" STREQUAL "${FALLBACK_VTK_VERSION}" AND "${VTK_BACKEND}" STREQUAL "${DEFAULT_VTK_BACKEND}")
  set(VTK_BACKEND "OpenGL")
  message("Forcing VTK_BACKEND to OpenGL instead of OpenGL2, due to VTK_VERSION=${VTK_VERSION}")
endif()


######################################################################
# This is a list of all known GUI apps. Used for things like
# creating Mac OSX bundles, and each command line app gets copied
# into each OSX bundle.
######################################################################
set(_known_apps "")
set(BUILDING_GUIS OFF)
if (BUILD_QTVTKGUI)
  list(APPEND _known_apps QtVTKApp)
  set(BUILDING_GUIS ON)
endif()
if (BUILD_QMLDEMO)
  list(APPEND _known_apps QMLDemo)
  set(BUILDING_GUIS ON)
endif()
set_property(GLOBAL PROPERTY MYPROJECT_GUI_APPS ${_known_apps})


##############################################################################
# Further variables for the external project names and locations are defined
# in the external project CMake files under CMake/ExternalProjects.
##############################################################################
set(NIFTK_EP_TARBALL_LOCATION "http://cmic.cs.ucl.ac.uk/platform/dependencies")


######################################################################
# MYPROJECT uses KWStyle for checking the coding style
######################################################################
include(${CMAKE_SOURCE_DIR}/Utilities/KWStyle/MYPROJECTKWStyle.cmake)


######################################################################
# MYPROJECT uses CppCheck for static analysis
######################################################################
include(${CMAKE_SOURCE_DIR}/Utilities/CppCheck/MYPROJECTCppCheck.cmake)


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


#########################################################################
# This is used to build up a list of all directories to search for .dlls.
#########################################################################
set(ADDITIONAL_SEARCH_PATHS "")


######################################################################
# Check for Qt early, as VTK may need it in SuperBuild.
######################################################################
set(QT5_LINK_LIBRARIES)
include(mpIncludeQt)


######################################################################
# Choose C++ standard
######################################################################
set(MYPROJECT_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS 0)
set(CMAKE_CXX_STANDARD ${MYPROJECT_CXX_STANDARD})
set(CMAKE_CXX_STANDARD_REQUIRED 1)

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
#   We configure up to this point (see the return() statement)
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


######################################################################
# Provide support for manually running Doxygen in build folder.
######################################################################
configure_file(${CMAKE_SOURCE_DIR}/Utilities/Doxygen/myprojectdoxygen.pl.in ${CMAKE_BINARY_DIR}/myprojectdoxygen.pl)
configure_file(${CMAKE_SOURCE_DIR}/Utilities/Doxygen/doxygen.config.in ${CMAKE_BINARY_DIR}/doxygen.config)


######################################################################
# Organise module/plugin/etc projects better within the IDE.
######################################################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON)


######################################################################
# Add Mandatory Requirements
######################################################################
set(ALL_THIRD_PARTY_LIBRARIES)
list(APPEND ADDITIONAL_SEARCH_PATHS "${CMAKE_BINARY_DIR}/bin/${VS_BUILD_TYPE}")


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

if(BUILD_PCL)
  # Example of:
  #   (1) When SuperBuild builds PCL it adds PCL_DIR to CMAKE_PREFIX_PATH
  #       So, PCL is found using PCL's provided PCLConfig.cmake.
  #       Its called 'config mode' when running find_package
  #       Its the preferred approach because PCL can then control what is exposed.
  set(PCL_FIND_QUIETLY ON)
  find_package(PCL REQUIRED)
  include_directories(${PCL_INCLUDE_DIRS})
  link_directories(${PCL_LIBRARY_DIRS})
  add_definitions(${PCL_DEFINITIONS})
  list(APPEND ALL_THIRD_PARTY_LIBRARIES ${PCL_LIBRARIES})

  # This appears to be missing from the list of PCL_LIBRARIES,
  # but I don't yet know why.
  find_library(_pcl_io_ply_LIBRARY
    NAMES pcl_io_ply
    PATHS ${PCL_LIBRARY_DIRS}
    NO_DEFAULT_PATH
  )
  if(_pcl_io_ply_LIBRARY)
    list(APPEND ALL_THIRD_PARTY_LIBRARIES ${_pcl_io_ply_LIBRARY})
  endif()

  add_definitions(-DBUILD_PCL)
  list(APPEND ADDITIONAL_SEARCH_PATHS "${PCL_LIBRARY_DIRS}/../${_library_sub_dir}")
  list(APPEND ADDITIONAL_SEARCH_PATHS "${FLANN_DIR}/${_library_sub_dir}")
  configure_file(${CMAKE_SOURCE_DIR}/Documentation/Licenses/PCL.txt ${CMAKE_BINARY_DIR}/LICENSE_PCL.txt)
  install(FILES ${CMAKE_BINARY_DIR}/LICENSE_PCL.txt DESTINATION . COMPONENT CONFIG)
endif()


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

######################################################################
# Add support for OpenMP.
######################################################################
if(MYPROJECT_USE_OPENMP)
  # Borrowed from PCL-1.8
  if((NOT APPLE) OR (NOT CMAKE_COMPILER_IS_GNUCXX) OR (GCC_VERSION VERSION_GREATER 4.2.1) OR (CMAKE_COMPILER_IS_CLANG))
    find_package(OpenMP)
    if(OpenMP_FOUND)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
      if(MSVC)
        if(MSVC_VERSION EQUAL 1500)
          set(OPENMP_DLL VCOMP90)
        elseif(MSVC_VERSION EQUAL 1600)
          set(OPENMP_DLL VCOMP100)
        elseif(MSVC_VERSION EQUAL 1700)
          set(OPENMP_DLL VCOMP110)
        elseif(MSVC_VERSION EQUAL 1800)
          set(OPENMP_DLL VCOMP120)
        elseif(MSVC_VERSION EQUAL 1900)
          set(OPENMP_DLL VCOMP140)
        elseif(MSVC_VERSION EQUAL 1910)
          set(OPENMP_DLL VCOMP140)
        endif()
        if(OPENMP_DLL)
          set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /DELAYLOAD:${OPENMP_DLL}D.dll")
          set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DELAYLOAD:${OPENMP_DLL}.dll")
        else(OPENMP_DLL)
          message(WARNING "Delay loading flag for OpenMP DLL is invalid.")
        endif(OPENMP_DLL)
      endif(MSVC)
    endif()
  else()
    message(FATAL_ERROR "You requested OpenMP, but your compiler does not support it. Please turn MYPROJECT_USE_OPENMP off.")
  endif()
  if(NOT OpenMP_FOUND)
    message(FATAL_ERROR "You requested OpenMP, but it was not found. Please turn MYPROJECT_USE_OPENMP off.")
  endif()
endif()


######################################################################
# Add support for MPI.
######################################################################
if(MYPROJECT_USE_MPI)
  find_package(MPI REQUIRED)
  message("Found MPI, with mpiexec=${MPIEXEC}")

  # Assume, for the purpose of this example project, that we are doing c++.
  # If you fork this project, you should set the variables in your chosen language.
  include_directories(${MPI_CXX_INCLUDE_PATH})
  list(APPEND CMAKE_CXX_FLAGS ${MPI_CXX_COMPILE_FLAGS})
  list(APPEND CMAKE_EXE_LINKER_FLAGS ${MPI_CXX_LINK_FLAGS})
  list(APPEND ALL_THIRD_PARTY_LIBRARIES ${MPI_CXX_LIBRARIES})

  message("Adding MPI include: ${MPI_CXX_INCLUDE_PATH}.")
  message("Adding MPI libs: ${MPI_CXX_LIBRARIES}.")

endif()


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
  set(output_dir ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_${type}_OUTPUT_DIRECTORY ${output_dir} CACHE INTERNAL "Single output directory for building all libraries.")
  mark_as_advanced(CMAKE_${type}_OUTPUT_DIRECTORY)
endforeach()

include_directories(${CMAKE_SOURCE_DIR}/Code/Lib)


##########################################################################################
# The next two generate CMake code to enable external projects to correctly use MYPROJECT.
##########################################################################################
configure_file(${CMAKE_SOURCE_DIR}/UseMyProject.cmake.in ${CMAKE_BINARY_DIR}/UseMyProject.cmake @ONLY IMMEDIATE)
configure_file(${CMAKE_SOURCE_DIR}/MyProjectConfig.cmake.in ${CMAKE_BINARY_DIR}/MyProjectConfig.cmake @ONLY IMMEDIATE)
if(NOT BUILDING_GUIS)
  install(FILES ${CMAKE_BINARY_DIR}/UseMyProject.cmake DESTINATION . COMPONENT CONFIG)
  install(FILES ${CMAKE_BINARY_DIR}/MyProjectConfig.cmake DESTINATION . COMPONENT CONFIG)
endif()


######################################################################
# Add code folders.
######################################################################
add_subdirectory(Code)
add_subdirectory(Documentation)
if(BUILD_TESTING)
  set(TEMP_DIR ${CMAKE_BINARY_DIR}/Testing/Temporary)
  include_directories(${CMAKE_SOURCE_DIR}/Testing/)
  add_subdirectory(Testing)
endif()


######################################################################
# Packaging code.
######################################################################
set(MYPROJECT_PACKAGE_NAME "MyProject" CACHE STRING "")
if(WIN32)
  set(MYPROJECT_BASE_NAME "MyProject" CACHE STRING "")
else()
  set(MYPROJECT_BASE_NAME "myproject" CACHE STRING "")
endif()
set(MYPROJECT_VERSION_STRING "${MYPROJECT_VERSION_MAJOR}.${MYPROJECT_VERSION_MINOR}.${MYPROJECT_VERSION_PATCH}" CACHE STRING "String to describe fully named version" FORCE)
set(MYPROJECT_DEPLOY_NAME "${MYPROJECT_BASE_NAME}-${MYPROJECT_VERSION_STRING}" CACHE STRING "" FORCE)
set(MYPROJECT_CONTACT "Your Name Here <your@email.com>" CACHE STRING "")

# 1. Setup defaults, common for all generators.
include(CPackSetup)

# 2. Configuring the Start Menu and Desktop icon strings for NSIS
if (WIN32)
  set(ICONS_SETUP_STRING "")
  set(ICONS_REMOVE_STRING "")
  set(DESKTOP_ICONS_SETUP_STRING "")
  set(DESKTOP_ICONS_REMOVE_STRING "")
  set(DESKTOP_ICONS_REMOVE_STRING "")

  get_property(_apps GLOBAL PROPERTY MYPROJECT_GUI_APPS)

  foreach(app_name ${_apps})

    message("Current App Name: ${app_name}")

    set(ICONS_SETUP_STRING "${ICONS_SETUP_STRING}CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\${app_name}.lnk' '$INSTDIR\\\\bin\\\\${app_name}.exe'\n")
    set(ICONS_REMOVE_STRING "${ICONS_REMOVE_STRING}Delete '$SMPROGRAMS\\\\$MUI_TEMP\\\\${app_name}.lnk'\n")

    set(DESKTOP_ICONS_SETUP_STRING "${DESKTOP_ICONS_SETUP_STRING}CreateShortCut '$DESKTOP\\\\${app_name}.lnk' '$INSTDIR\\\\bin\\\\${app_name}.exe'\n")
    set(DESKTOP_ICONS_REMOVE_STRING "${DESKTOP_ICONS_REMOVE_STRING}Delete '$DESKTOP\\\\${app_name}.lnk'\n")
  endforeach()
endif()

# 3. Set variables that may be platform (Windows/Linux/Mac) or Generator (TGZ,DEB,NSIS) specific.
#    When CPack runs, it just uses all the information in the generated files cmake_install.cmake.
#    So, CPack does not read all your configuration information in CMakeLists.txt, and CPack
#    does not re-run any cmake process.  So, it is cmake that reads all the CMakeLists.txt files
#    and generates all the cmake_install.cmake.  So this command will use cmake to generate
#    and additional file, that we can politely ask cpack to include, in addition to all the
#    cmake_install.cmake files.

configure_file(${CMAKE_SOURCE_DIR}/CMake/CPackOptions.cmake.in
               ${CMAKE_BINARY_DIR}/MYPROJECTCPackOptions.cmake @ONLY IMMEDIATE)

# 4. Set a variable with the name of this file.
set(CPACK_PROJECT_CONFIG_FILE "${CMAKE_BINARY_DIR}/MYPROJECTCPackOptions.cmake")

# 5. Include this optional file.
include(MYPROJECTCPackOptions)

# 6. Include CPack module once all variables are set.
include(CPack)


######################################################################
# If we are under Windows, create batch files which correctly
# set up the environment for Visual Studio. These are only used to
# start VS when developing. Not used in the final installation package.
######################################################################
if(WIN32)
  set(VS_SOLUTION_FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}.sln")
  foreach(VS_BUILD_TYPE ${CMAKE_CONFIGURATION_TYPES})
    configure_file("${CMAKE_SOURCE_DIR}/CMake/StartVS.bat.in" ${PROJECT_BINARY_DIR}/StartVS_${VS_BUILD_TYPE}.bat @ONLY)
    message( "CreateWindowsBatchScript: Creating ${PROJECT_BINARY_DIR}/StartVS_${VS_BUILD_TYPE}.bat" )
  endforeach()
endif(WIN32)
