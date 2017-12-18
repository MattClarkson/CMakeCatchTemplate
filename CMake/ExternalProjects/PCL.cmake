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
# PCL - Point Cloud Library..
#-----------------------------------------------------------------------------
if(NOT BUILD_PCL)
  return()
endif()

# Sanity checks
if(DEFINED PCL_DIR AND NOT EXISTS ${PCL_DIR})
  message(FATAL_ERROR "PCL_DIR variable is defined but corresponds to non-existing directory \"${PCL_DIR}\".")
endif()

set(version "c230159f92")
set(location "${NIFTK_EP_TARBALL_LOCATION}/PointCloudLibrary-pcl-${version}.tar.gz")
mpMacroDefineExternalProjectVariables(PCL ${version} ${location})
set(proj_DEPENDENCIES Boost Eigen FLANN)
if (BUILD_VTK)
  list(APPEND proj_DEPENDENCIES VTK)
endif()

if(NOT DEFINED PCL_DIR)

  set(_vtk_options)
  if(BUILD_VTK)
    set(_vtk_options
      -DBUILD_visualization:BOOL=${BUILD_PCL_VIS}
      -DVTK_DIR:PATH=${VTK_DIR}
    )
  endif()

  set(_cuda_options
    -DBUILD_CUDA:BOOL=${MYPROJECT_USE_CUDA}
    -DBUILD_GPU:BOOL=${MYPROJECT_USE_CUDA}
  )
  endif()
  if(MYPROJECT_USE_CUDA)
    list(APPEND _cuda_options
      -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
      -DCUDA_ARCH_BIN:STRING=${MYPROJECT_CUDA_ARCH_BIN}
      -DCUDA_NVCC_FLAGS:STRING=${MYPROJECT_CXX11_FLAG}
      -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF
      -DBUILD_gpu_tracking:BOOL=ON
      -DBUILD_gpu_utils:BOOL=ON
    )
    if(NOT APPLE)
      list(APPEND _cuda_options
        -DBUILD_gpu_surface:BOOL=OFF # Can't compile this on OSX 10.10, CUDA 7.0, clang 6.0. Other platforms and versions may work.
      )
    endif()
  endif()

  set(_build_static ON)
  if(BUILD_SHARED_LIBS)
    set(_build_static OFF)
  endif()

  ExternalProject_Add(${proj}
    LIST_SEPARATOR ^^
    PREFIX ${proj_CONFIG}
    SOURCE_DIR ${proj_SOURCE}
    BINARY_DIR ${proj_BUILD}
    INSTALL_DIR ${proj_INSTALL}
    URL ${proj_LOCATION}
    URL_MD5 ${proj_CHECKSUM}
    PATCH_COMMAND ${PATCH_COMMAND} -N -p1 -i ${CMAKE_CURRENT_LIST_DIR}/PCL.patch
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${EP_COMMON_ARGS}
      -DCMAKE_PREFIX_PATH:PATH=${MYPROJECT_PREFIX_PATH}
      -DCMAKE_DEBUG_POSTFIX:STRING=
      -DBOOST_ROOT:PATH=${BOOST_ROOT}
      -DBOOST_INCLUDEDIR:PATH=${BOOST_ROOT}/include
      -DBOOST_LIBRARYDIR:PATH=${BOOST_ROOT}/lib
      -DBoost_LIBRARY_DIR:PATH=${BOOST_ROOT}/lib 
      -DBoost_NO_SYSTEM_PATHS:BOOL=ON
      -DBoost_USE_STATIC_LIBS:BOOL=${_build_static}
      -DBoost_USE_STATIC_RUNTIME:BOOL=${_build_static}
      -DPCL_BUILD_WITH_BOOST_DYNAMIC_LINKING_WIN32:BOOL=${BUILD_SHARED_LIBS}
      -DEIGEN_ROOT:PATH=${Eigen_DIR}
      -DEIGEN_INCLUDE_DIR:PATH=${Eigen_INCLUDE_DIR}
      -DFLANN_ROOT:PATH=${FLANN_DIR}
      -DPCL_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DOPENGL_glu_LIBRARY=${OPENGL_glu_LIBRARY}
      -DOPENGL_gl_LIBRARY=${OPENGL_gl_LIBRARY}
      -DBUILD_apps:BOOL=OFF
      -DBUILD_tools:BOOL=ON
      -DBUILD_examples:BOOL=OFF
      -DWITH_LIBUSB:BOOL=OFF    # On my Mac, this pulls in a dependency to /opt/local (MacPorts) which has the wrong version of boost.
      -DWITH_PNG:BOOL=OFF       # Same problem
      -DWITH_QHULL:BOOL=OFF     # Same problem
      -DWITH_OPENNI:BOOL=OFF    # Same problem, but worse: For each device, PCL defaults this to TRUE, so FindX is always executed.
      -DWITH_OPENNI2:BOOL=OFF   # Same problem, but worse: For each device, PCL defaults this to TRUE, so FindX is always executed.
      -DWITH_PCAP:BOOL=OFF      # On my Mac, this is 32 bit, so barfs when linking 64 bit.
      ${_vtk_options}
      ${_cuda_options}
    CMAKE_CACHE_ARGS
      ${EP_COMMON_CACHE_ARGS}
    CMAKE_CACHE_DEFAULT_ARGS
      ${EP_COMMON_CACHE_DEFAULT_ARGS}
    DEPENDS ${proj_DEPENDENCIES}
  )

  set(PCL_DIR ${proj_INSTALL})

  set(MYPROJECT_PREFIX_PATH ${proj_INSTALL}^^${MYPROJECT_PREFIX_PATH})
  mitkFunctionInstallExternalCMakeProject(${proj})

  message("SuperBuild loading PCL from ${PCL_DIR}")

else()

  mitkMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")

endif()

