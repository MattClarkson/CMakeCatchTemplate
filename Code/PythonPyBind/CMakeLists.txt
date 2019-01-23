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
    set(MYPROJECT_PYTHON_MODULE_NAME "${PROJECT_NAME}Python" CACHE STRING "Basename for python module.")
  endif()

  set(MYPROJECT_PYTHON_SRCS
    mpLibPython.cpp
  )
  add_subdirectory(pybind11)
  link_libraries(${ALL_LIBRARIES})
  pybind11_add_module(${MYPROJECT_PYTHON_MODULE_NAME} ${MYPROJECT_PYTHON_SRCS})
  if(APPLE)
    set_target_properties(${MYPROJECT_PYTHON_MODULE_NAME} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
  endif()
  if(UNIX AND NOT APPLE)
    set_target_properties(${MYPROJECT_PYTHON_MODULE_NAME} PROPERTIES LINK_FLAGS "--unresolved-symbols=ignore-in-shared-libs")
  endif()
  install(TARGETS ${MYPROJECT_PYTHON_MODULE_NAME} DESTINATION ${MYPROJECT_INSTALL_LIB_DIR})

endif()
