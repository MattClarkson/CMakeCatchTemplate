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

if(NOT BUILDING_GUIS)

  if (NOT MYPROJECT_PYTHON_MODULE_NAME OR MYPROJECT_PYTHON_MODULE_NAME STREQUAL "")
    get_filename_component(_proj_name ${PROJECT_SOURCE_DIR} NAME)
    set(MYPROJECT_PYTHON_MODULE_NAME "${_proj_name}-python" CACHE STRING "Basename for python module.")
  endif()

  set(MYPROJECT_PYTHON_SRCS
    mpLibPython.cpp
  )
  add_subdirectory(pybind11)
  link_libraries(${MYPROJECT_LIBRARY_NAME})
  pybind11_add_module(${MYPROJECT_PYTHON_MODULE_NAME} ${MYPROJECT_PYTHON_SRCS})
  install(TARGETS ${MYPROJECT_PYTHON_MODULE_NAME} DESTINATION ${MYPROJECT_INSTALL_LIB_DIR})

endif()
