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

option(BUILD_Python_Boost "Build boost::python bindings." OFF)
option(BUILD_Python_PyBind "Build PyBind11 bindings." OFF)

if(BUILD_Python_Boost AND BUILD_Python_PyBind)
  message(FATAL_ERROR "BUILD_Python_Boost and BUILD_Python_PyBind are mutually exclusive. Please pick one or the other!")
endif()

if (BUILD_Python_Boost AND WIN32) # Seems ok on Linux/Mac, I don't want to be too restrictive.
  set(MYPROJECT_CMAKE_MINIMUM_REQUIRED_VERSION 3.12) # Assuming Boost 1.67
  cmake_minimum_required(VERSION ${MYPROJECT_CMAKE_MINIMUM_REQUIRED_VERSION})
endif()

if(BUILD_Python_Boost OR BUILD_Python_PyBind)

  if (DEFINED MYPROJECT_PYTHON_VERSION)
    find_package(PythonInterp ${MYPROJECT_PYTHON_VERSION} EXACT REQUIRED)
    find_package(PythonLibs ${MYPROJECT_PYTHON_VERSION} REQUIRED)
  else()
    find_package(PythonInterp)
    find_package(PythonLibs)
  endif()

  message("Found python interpreter: ${PYTHON_EXECUTABLE}")
  message("Found python library version: ${PYTHONLIBS_VERSION_STRING}")
  message("Found python include dirs: ${PYTHON_INCLUDE_DIRS}")

  if (NOT PythonLibs_FOUND OR NOT PythonInterp_FOUND)
    set(BUILD_Python_Boost OFF CACHE BOOL "Build boost::python bindings." FORCE)
    set(BUILD_Python_PyBind OFF CACHE BOOL "Build PyBind11 bindings." FORCE)
    message("Forcing BUILD_Python_Boost and BUILD_Python_PyBind to OFF as no Python libs were found.")
  endif()

  if(BUILD_Python_Boost)
    list(APPEND MYPROJECT_BOOST_LIBS "system")
    if (WITHIN_SUBBUILD)
      list(APPEND MYPROJECT_BOOST_LIBS "python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")

	  # Add this if you want numpy. Depends on your build env.
	  # I've left it out for now, as cloned projects can decide if they need it.
	  # It doesn't warrant another top level flag.
	  # list(APPEND MYPROJECT_BOOST_LIBS "numpy${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")
    else()
      list(APPEND MYPROJECT_BOOST_LIBS "python")
    endif()
    list(REMOVE_DUPLICATES MYPROJECT_BOOST_LIBS)
  endif()
endif()
