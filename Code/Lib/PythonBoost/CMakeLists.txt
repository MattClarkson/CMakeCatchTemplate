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

  # if running pip install, MYPROJECT_PYTHON_MODULE_NAME is passed in from setup.py
  # So, if its not specified, we just name it after the current library with a 'python' suffix.
  if (NOT MYPROJECT_PYTHON_MODULE_NAME OR MYPROJECT_PYTHON_MODULE_NAME STREQUAL "")
    set(MYPROJECT_PYTHON_MODULE_NAME "${MYPROJECT_LIBRARY_NAME}python")
  endif()

  set(MYPROJECT_PYTHON_SRCS
    mpLibPython.cpp
  )

  link_libraries(${MYPROJECT_LIBRARY_NAME})
  PYTHON_ADD_MODULE(${MYPROJECT_PYTHON_MODULE_NAME} ${MYPROJECT_PYTHON_SRCS})
  install(TARGETS ${MYPROJECT_PYTHON_MODULE_NAME} DESTINATION ${MYPROJECT_INSTALL_LIB_DIR})

endif()
