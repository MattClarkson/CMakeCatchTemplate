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

if(BUILD_PYTHON_BINDINGS)
  include_directories(${PYTHON_INCLUDE_DIRS})
  link_libraries(${PYTHON_LIBRARIES})
  link_libraries(${Boost_LIBRARIES})
endif()
