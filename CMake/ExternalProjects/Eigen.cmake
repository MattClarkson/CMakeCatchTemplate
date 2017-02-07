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
# Eigen
#-----------------------------------------------------------------------------
if(NOT BUILD_Eigen)
  return()
endif()

# Sanity checks
if(DEFINED Eigen_DIR AND NOT EXISTS ${Eigen_DIR})
  message(FATAL_ERROR "Eigen_DIR variable is defined but corresponds to non-existing directory \"${Eigen_ROOT}\".")
endif()

set(version "3.2.2.1")
set(location "${NIFTK_EP_TARBALL_LOCATION}/eigen-eigen-${version}.tar.bz2")

mpMacroDefineExternalProjectVariables(Eigen ${version} ${location})

if(NOT DEFINED Eigen_DIR)

  ExternalProject_Add(${proj}
    LIST_SEPARATOR ^^
    PREFIX ${proj_CONFIG}
    SOURCE_DIR ${proj_SOURCE}
    BINARY_DIR ${proj_BUILD}
    INSTALL_DIR ${proj_INSTALL}
    URL ${proj_LOCATION}
    URL_MD5 ${proj_CHECKSUM}
    #CONFIGURE_COMMAND ""
    UPDATE_COMMAND ""
    BUILD_COMMAND ""
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${EP_COMMON_ARGS}
      -DCMAKE_PREFIX_PATH:PATH=${MYPROJECT_PREFIX_PATH}
      -DEIGEN_LEAVE_TEST_IN_ALL_TARGET=ON
    CMAKE_CACHE_ARGS
      ${EP_COMMON_CACHE_ARGS}
    CMAKE_CACHE_DEFAULT_ARGS
      ${EP_COMMON_CACHE_DEFAULT_ARGS}
    DEPENDS ${proj_DEPENDENCIES}
  )

  set(Eigen_SOURCE_DIR ${proj_SOURCE})
  set(Eigen_DIR ${proj_INSTALL})
  set(Eigen_INCLUDE_DIR ${Eigen_DIR}/include/eigen3)

  set(MYPROJECT_PREFIX_PATH ${proj_INSTALL}^^${MYPROJECT_PREFIX_PATH})
  mitkFunctionInstallExternalCMakeProject(${proj})

  message("SuperBuild loading Eigen from ${Eigen_SOURCE_DIR} (PCL) or ${Eigen_DIR} (anything else).")

else(NOT DEFINED Eigen_DIR)

  mitkMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")

endif(NOT DEFINED Eigen_DIR)
