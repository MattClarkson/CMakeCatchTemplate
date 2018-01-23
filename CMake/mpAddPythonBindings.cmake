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

option(BUILD_PYTHON_BINDINGS "Build Python Bindings." OFF)

if(BUILD_PYTHON_BINDINGS)
  find_package(PythonInterp REQUIRED)
  message("Found python interpreter: ${PYTHON_EXECUTABLE}")
  find_package(PythonLibs REQUIRED)
  message("Found python library version: ${PYTHONLIBS_VERSION_STRING}")
  list(APPEND MYPROJECT_BOOST_LIBS "system")
  if (${PYTHON_VERSION_MAJOR} EQUAL 3 AND WITHIN_SUBBUILD)
    list(APPEND MYPROJECT_BOOST_LIBS "python3")
  else()
    list(APPEND MYPROJECT_BOOST_LIBS "python")
  endif()
  list(REMOVE_DUPLICATES MYPROJECT_BOOST_LIBS)
endif()
