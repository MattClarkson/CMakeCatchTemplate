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

#-----------------------------------------------------------------------------
# Convenient macro allowing to download a file
#-----------------------------------------------------------------------------

include(mitkFunctionInstallExternalCMakeProject)

macro(downloadFile url dest)
  file(DOWNLOAD ${url} ${dest} STATUS status)
  list(GET status 0 error_code)
  list(GET status 1 error_msg)
  if(error_code)
    message(FATAL_ERROR "error: Failed to download ${url} - ${error_msg}")
  endif()
endmacro()

# We need a proper patch program. On Linux and MacOS, we assume
# that "patch" is available. On Windows, we download patch.exe
# if no patch program is found.
find_program(PATCH_COMMAND patch)
if((NOT PATCH_COMMAND OR NOT EXISTS ${PATCH_COMMAND}) AND WIN32)
  downloadFile(${NIFTK_EP_TARBALL_LOCATION}/patch.exe
               ${CMAKE_CURRENT_BINARY_DIR}/patch.exe)
  find_program(PATCH_COMMAND patch ${CMAKE_CURRENT_BINARY_DIR})
endif()
if(NOT PATCH_COMMAND)
  message(FATAL_ERROR "No patch program found.")
endif()

include(ExternalProject)

set(EP_BASE "${CMAKE_BINARY_DIR}" CACHE PATH "Directory where the external projects are configured and built")
set_property(DIRECTORY PROPERTY EP_BASE ${EP_BASE})

# This option makes different versions of the same external project build in separate directories.
# This allows switching branches in the MYPROJECT source code and build MYPROJECT quickly, even if the
# branches use different versions of the same library. A given version of an EP will be built only
# once. A drawback is that the EP_BASE directory can become big easily.
# Note:
# If you switch branches that need different versions of EPs, you might need to delete the
# MYPROJECT-configure timestamp manually before doing a superbuild. Without that the CMake cache is
# not regenerated and it may still store the paths to the EP versions that belong to the original
# branch (from which you switched). You have been warned.

set(EP_DIRECTORY_PER_VERSION FALSE CACHE BOOL "Use separate directories for different versions of the same external project.")

mark_as_advanced(EP_BASE)
mark_as_advanced(EP_DIRECTORY_PER_VERSION)

# Compute -G arg for configuring external projects with the same CMake generator:
if(CMAKE_EXTRA_GENERATOR)
  set(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
  set(gen "${CMAKE_GENERATOR}")
endif()

if(MSVC)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /bigobj /MP /W0 /Zi")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /bigobj /MP /W0 /Zi")
  # we want symbols, even for release builds!
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /debug")
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /debug")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /debug")
  set(CMAKE_CXX_WARNING_LEVEL 0)
else()
  if(${BUILD_SHARED_LIBS})
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLINUX_EXTRA")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DLINUX_EXTRA")
  else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -DLINUX_EXTRA")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -DLINUX_EXTRA")
  endif()
endif()

# This is a workaround for passing linker flags
# actually down to the linker invocation
set(_cmake_required_flags_orig ${CMAKE_REQUIRED_FLAGS})
set(CMAKE_REQUIRED_FLAGS "-Wl,-rpath")
mitkFunctionCheckCompilerFlags(${CMAKE_REQUIRED_FLAGS} _has_rpath_flag)
set(CMAKE_REQUIRED_FLAGS ${_cmake_required_flags_orig})

set(_install_rpath_linkflag )
if(_has_rpath_flag)
  if(APPLE)
    set(_install_rpath_linkflag "-Wl,-rpath,@loader_path/../lib")
  else()
    set(_install_rpath_linkflag "-Wl,-rpath='$ORIGIN/../lib'")
  endif()
endif()

set(_install_rpath)
if(APPLE)
  set(_install_rpath "@loader_path/../lib")
elseif(UNIX)
  # this works for libraries as well as executables
  set(_install_rpath "\$ORIGIN/../lib")
endif()

# Experimental code to install external project libraries with RPATH.
# It is used when EP_ALWAYS_USE_INSTALL_DIR is enabled.
# It is known to break the packaging on Mac and Linux.
set(INSTALL_WITH_RPATH ${EP_ALWAYS_USE_INSTALL_DIR})
if (INSTALL_WITH_RPATH)

  # This is a workaround for passing linker flags
  # actually down to the linker invocation
  set(_cmake_required_flags_orig ${CMAKE_REQUIRED_FLAGS})
  set(CMAKE_REQUIRED_FLAGS "-Wl,-rpath")
  mitkFunctionCheckCompilerFlags(${CMAKE_REQUIRED_FLAGS} _has_rpath_flag)
  set(CMAKE_REQUIRED_FLAGS ${_cmake_required_flags_orig})

  set(_install_rpath_linkflag )
  if(_has_rpath_flag)
    if(APPLE)
      set(_install_rpath_linkflag "-Wl,-rpath,@loader_path/../lib")
    else()
      set(_install_rpath_linkflag "-Wl,-rpath='$ORIGIN/../lib'")
    endif()
  endif()

  set(_install_rpath)
  if(APPLE)
    set(_install_rpath "@loader_path/../lib")
  elseif(UNIX)
    # this work for libraries as well as executables
    set(_install_rpath "\$ORIGIN/../lib")
  endif()

endif (INSTALL_WITH_RPATH)

set(EP_COMMON_ARGS
  -DCMAKE_CXX_EXTENSIONS:STRING=${CMAKE_CXX_EXTENSIONS}
  -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
  -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}
  -DCMAKE_MACOSX_RPATH:BOOL=TRUE
  "-DCMAKE_INSTALL_RPATH:STRING=${_install_rpath}"
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
  -DBUILD_TESTING:BOOL=OFF
  -DBUILD_EXAMPLES:BOOL=OFF
  -DDESIRED_QT_VERSION:STRING=${DESIRED_QT_VERSION}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_CONFIGURATION_TYPES:STRING=${CMAKE_CONFIGURATION_TYPES}
  -DCMAKE_VERBOSE_MAKEFILE:BOOL=${CMAKE_VERBOSE_MAKEFILE}
  -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
  -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
  "-DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS} ${MYPROJECT_CXX11_FLAG}"
  #debug flags
  -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
  -DCMAKE_C_FLAGS_DEBUG:STRING=${CMAKE_C_FLAGS_DEBUG}
  #release flags
  -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
  -DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}
  #relwithdebinfo
  -DCMAKE_CXX_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_CXX_FLAGS_RELWITHDEBINFO}
  -DCMAKE_C_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_C_FLAGS_RELWITHDEBINFO}
  #link flags
  -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
  -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
  -DCMAKE_MODULE_LINKER_FLAGS:STRING=${CMAKE_MODULE_LINKER_FLAGS}
)

set(MYPROJECT_SUPERBUILD_DEBUG_POSTFIX d)
list(APPEND EP_COMMON_ARGS -DCMAKE_DEBUG_POSTFIX:STRING=d)

set(EP_COMMON_CACHE_DEFAULT_ARGS
  "-DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>;${CMAKE_PREFIX_PATH}"
  "-DCMAKE_INCLUDE_PATH:PATH=${CMAKE_INCLUDE_PATH}"
  "-DCMAKE_LIBRARY_PATH:PATH=${CMAKE_LIBRARY_PATH}"
)

if(INSTALL_WITH_RPATH)
  set(EP_COMMON_ARGS
       "-DCMAKE_INSTALL_RPATH:STRING=${_install_rpath}"
       ${EP_COMMON_ARGS}
      )
endif()

if(APPLE)
  set(EP_COMMON_ARGS
       -DCMAKE_OSX_ARCHITECTURES:PATH=${CMAKE_OSX_ARCHITECTURES}
       -DCMAKE_OSX_DEPLOYMENT_TARGET:PATH=${CMAKE_OSX_DEPLOYMENT_TARGET}
       -DCMAKE_OSX_SYSROOT:PATH=${CMAKE_OSX_SYSROOT}
       ${EP_COMMON_ARGS}
      )
endif()

######################################################################
# Include External Project helper macros
######################################################################

include(mpExternalProjectHelperMacros)

######################################################################
# External projects
######################################################################
foreach(p gflags glog Eigen OpenCV Boost)
  include("CMake/ExternalProjects/${p}.cmake")
endforeach()


######################################################################
# Now compile MYPROJECT, using the packages we just provided.
######################################################################
if(NOT DEFINED SUPERBUILD_EXCLUDE_MYPROJECTBUILD_TARGET OR NOT SUPERBUILD_EXCLUDE_MYPROJECTBUILD_TARGET)

  set(proj MYPROJECT)
  set(proj_DEPENDENCIES ${OpenCV_DEPENDS} ${Eigen_DEPENDS} ${Boost_DEPENDS} ${gflags_DEPENDS} ${glog_DEPENDS})

  ExternalProject_Add(${proj}
    LIST_SEPARATOR ^^
    DOWNLOAD_COMMAND ""
    INSTALL_COMMAND ""
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINARY_DIR ${proj}-build
    PREFIX ${proj}-cmake
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${EP_COMMON_ARGS}
      -DCMAKE_DEBUG_POSTFIX:STRING=
      -DCMAKE_PREFIX_PATH:PATH=${MYPROJECT_PREFIX_PATH}
      -DMYPROJECT_SUPERBUILD_DEBUG_POSTFIX:STRING=${MYPROJECT_SUPERBUILD_DEBUG_POSTFIX}
    CMAKE_CACHE_ARGS
      ${EP_COMMON_CACHE_ARGS}
      -DCMAKE_LIBRARY_PATH:PATH=${CMAKE_LIBRARY_PATH}
      -DCMAKE_INCLUDE_PATH:PATH=${CMAKE_INCLUDE_PATH}
      -DMYPROJECT_EXTERNAL_PROJECT_PREFIX:PATH=${ep_prefix}
      -DMYPROJECT_USE_KWSTYLE:BOOL=${MYPROJECT_USE_KWSTYLE}
      -DMYPROJECT_USE_CPPCHECK:BOOL=${MYPROJECT_USE_CPPCHECK}
      -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
      -DCMAKE_VERBOSE_MAKEFILE:BOOL=${CMAKE_VERBOSE_MAKEFILE}
      -DBUILD_TESTING:BOOL=${BUILD_TESTING} # The value set in EP_COMMON_ARGS normally forces this off, but we may need MYPROJECT to be on.
      -DBUILD_SUPERBUILD:BOOL=OFF           # Must force this to be off, or else you will loop forever.
      -DWITHIN_SUPERBUILD:BOOL=ON
      -DBUILD_gflags:BOOL=${BUILD_gflags}
      -DBUILD_glog:BOOL=${BUILD_glog}
      -DBUILD_Eigen:BOOL=${BUILD_Eigen}
      -DBUILD_Boost:BOOL=${BUILD_Boost}
      -DBUILD_OpenCV:BOOL=${BUILD_OpenCV}
      -Dgflags_DIRECTORY:PATH=${gflags_DIR}
      -Dglog_DIRECTORY:PATH=${glog_DIR}
      -DBOOST_ROOT:PATH=${BOOST_ROOT}
      -DEigen_ROOT:PATH=${Eigen_DIR}
      -DEigen_INCLUDE_DIR:PATH=${Eigen_INCLUDE_DIR}
      -DOpenCV_DIR:PATH=${OpenCV_DIR}
      -DOPENCV_WITH_FFMPEG:BOOL=${OPENCV_WITH_FFMPEG}
      -DOPENCV_WITH_NONFREE:BOOL=${OPENCV_WITH_NONFREE}
    DEPENDS ${proj_DEPENDENCIES}
  )

endif()
