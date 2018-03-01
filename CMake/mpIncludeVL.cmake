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

if(BUILD_VL)
  find_package(OpenGL REQUIRED)
  include_directories(${OPENGL_INCLUDE_DIR})
  message("Found OpenGL:${OPENGL_INCLUDE_DIR}")
  set(_vl_components VLMain VLCore VLGraphics VLVolume)
  if(MYPROJECT_USE_QT)
    list(APPEND _vl_components VLQt5)
  endif()
  list(APPEND CMAKE_MODULE_PATH ${VL_ROOT}/cmake)
  find_package(VL COMPONENTS ${_vl_components} REQUIRED)
  message("Found VL: ${_vl_components}")
  include_directories(${VL_INCLUDE_DIRS})
  link_directories(${VL_LIBRARY_DIRS})
  list(APPEND ALL_THIRD_PARTY_LIBRARIES ${VL_LIBRARIES})
  add_definitions(-DBUILD_VL)
  list(APPEND ADDITIONAL_SEARCH_PATHS "${VL_ROOT}/${_library_sub_dir}")
  configure_file(${CMAKE_SOURCE_DIR}/Documentation/Licenses/VL.txt ${CMAKE_BINARY_DIR}/LICENSE_VL.txt)
  install(FILES ${CMAKE_BINARY_DIR}/LICENSE_VL.txt DESTINATION . COMPONENT CONFIG)
endif()
