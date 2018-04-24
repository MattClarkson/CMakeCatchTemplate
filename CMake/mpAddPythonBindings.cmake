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

if(BUILD_Python_Boost OR BUILD_Python_PyBind)

  find_package(PythonInterp)
  message("Found python interpreter: ${PYTHON_EXECUTABLE}")
  find_package(PythonLibs)
  message("Found python library version: ${PYTHONLIBS_VERSION_STRING}")

  if (NOT PythonLibs_FOUND)
    set(BUILD_Python_Boost OFF CACHE BOOL "Build boost::python bindings." FORCE)
    set(BUILD_Python_PyBind OFF CACHE BOOL "Build PyBind11 bindings." FORCE)
    message("Forcing BUILD_Python_Boost and BUILD_Python_PyBind to OFF as no Python libs were found.")
  endif()

  if (PythonLibs_FOUND)
    if(BUILD_Python_Boost OR BUILD_Python_PyBind)
      set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build Shared Libraries" FORCE)
      message("Forcing BUILD_SHARED_LIBS to OFF as you want a python module.")
    endif()
  endif()

  if(BUILD_Python_Boost)
    list(APPEND MYPROJECT_BOOST_LIBS "system")
    if (${PYTHON_VERSION_MAJOR} EQUAL 3 AND WITHIN_SUBBUILD)
      list(APPEND MYPROJECT_BOOST_LIBS "python3")
    else()
      list(APPEND MYPROJECT_BOOST_LIBS "python")
    endif()
    list(REMOVE_DUPLICATES MYPROJECT_BOOST_LIBS)
  endif()

endif()
