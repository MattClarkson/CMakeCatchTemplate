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
# VTK
#-----------------------------------------------------------------------------
if(NOT BUILD_VTK)
  return()
endif()

# Sanity checks
if(DEFINED VTK_DIR AND NOT EXISTS ${VTK_DIR})
  message(FATAL_ERROR "VTK_DIR variable is defined but corresponds to non-existing directory")
endif()

set(make_webkit_optional)
if( "${VTK_VERSION}" STREQUAL "6.1.0")
  set(make_webkit_optional COMMAND ${PATCH_COMMAND} -N -p1 -i ${CMAKE_CURRENT_LIST_DIR}/VTK.patch)
endif()

set(location "${NIFTK_EP_TARBALL_LOCATION}/VTK-${VTK_VERSION}.tar.gz")
mpMacroDefineExternalProjectVariables(VTK ${version} ${location})
set(proj_DEPENDENCIES )

if(WIN32)
  option(VTK_USE_SYSTEM_FREETYPE OFF)
else(WIN32)
  option(VTK_USE_SYSTEM_FREETYPE ON)
endif(WIN32)
mark_as_advanced(VTK_USE_SYSTEM_FREETYPE)

if(NOT DEFINED VTK_DIR)

  set(additional_cmake_args )
  if(MINGW)
    set(additional_cmake_args
        -DCMAKE_USE_WIN32_THREADS:BOOL=ON
        -DCMAKE_USE_PTHREADS:BOOL=OFF
        -DVTK_USE_VIDEO4WINDOWS:BOOL=OFF # no header files provided by MinGW
        )
  endif()

  # Optionally enable memory leak checks for any objects derived from vtkObject. This
  # will force unit tests to fail if they have any of these memory leaks.
  option(MYPROJECT_VTK_DEBUG_LEAKS OFF)
  mark_as_advanced(MYPROJECT_VTK_DEBUG_LEAKS)
  list(APPEND additional_cmake_args
       -DVTK_DEBUG_LEAKS:BOOL=${MITK_VTK_DEBUG_LEAKS}
      )

  list(APPEND additional_cmake_args
       -DVTK_WRAP_PYTHON:BOOL=OFF
       -DVTK_WINDOWS_PYTHON_DEBUGGABLE:BOOL=OFF
      )

  if(Qt5_DIR AND MYPROJECT_USE_QT)
    list(APPEND additional_cmake_args
        -DVTK_QT_VERSION:STRING=5
        -DVTK_Group_Qt:BOOL=ON
        -DVTK_INSTALL_NO_QT_PLUGIN:BOOL=ON
     )
  endif()

  if(CTEST_USE_LAUNCHERS)
    list(APPEND additional_cmake_args
      "-DCMAKE_PROJECT_${proj}_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake"
    )
  endif()

  if(APPLE)
    list(APPEND additional_cmake_args
        -DVTK_REQUIRED_OBJCXX_FLAGS:STRING=""
        )
  endif(APPLE)

  ExternalProject_Add(${proj}
    LIST_SEPARATOR ^^
    PREFIX ${proj_CONFIG}
    SOURCE_DIR ${proj_SOURCE}
    BINARY_DIR ${proj_BUILD}
    INSTALL_DIR ${proj_INSTALL}
    URL ${proj_LOCATION}
    URL_MD5 ${proj_CHECKSUM}
    PATCH_COMMAND ${make_webkit_optional}
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
        ${EP_COMMON_ARGS}
        -DCMAKE_PREFIX_PATH:PATH=${MYPROJECT_PREFIX_PATH}
        -DVTK_WRAP_TCL:BOOL=OFF
        -DVTK_WRAP_PYTHON:BOOL=OFF
        -DVTK_WRAP_JAVA:BOOL=OFF
        -DVTK_USE_SYSTEM_FREETYPE:BOOL=${VTK_USE_SYSTEM_FREETYPE}
        -DVTK_LEGACY_REMOVE:BOOL=ON
        -DModule_vtkTestingRendering:BOOL=ON
        -DVTK_MAKE_INSTANTIATORS:BOOL=ON
        -DVTK_USE_CXX11_FEATURES:BOOL=ON
        -DVTK_RENDERING_BACKEND:STRING=${VTK_BACKEND}
        ${additional_cmake_args}
    CMAKE_CACHE_ARGS
      ${EP_COMMON_CACHE_ARGS}
    CMAKE_CACHE_DEFAULT_ARGS
      ${EP_COMMON_CACHE_DEFAULT_ARGS}
    DEPENDS ${proj_DEPENDENCIES}
  )

  set(VTK_DIR ${proj_INSTALL})
  set(MYPROJECT_PREFIX_PATH ${proj_INSTALL}^^${MYPROJECT_PREFIX_PATH})
  mitkFunctionInstallExternalCMakeProject(${proj})

  message("SuperBuild loading VTK from ${VTK_DIR}")

else()

  mitkMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")

endif()
