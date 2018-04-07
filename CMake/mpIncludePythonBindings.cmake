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

# If running pip install, MYPROJECT_PYTHON_OUTPUT_DIRECTORY is passed in from setup.py
# So, if its not specified, we just put python library in same output folder as all other binaries.
if(NOT MYPROJECT_PYTHON_OUTPUT_DIRECTORY OR MYPROJECT_PYTHON_OUTPUT_DIRECTORY STREQUAL "")
  set(MYPROJECT_PYTHON_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
endif()

if(BUILD_Python_Boost OR BUILD_Python_PyBind)
  include_directories(${PYTHON_INCLUDE_DIRS})
  link_libraries(${PYTHON_LIBRARIES})
endif()

if(BUILD_Python_PyBind)
  include_directories(${PYTHON_INCLUDE_DIRS})
endif()

