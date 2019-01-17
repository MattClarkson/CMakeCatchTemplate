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
    set(MYPROJECT_PYTHON_MODULE_NAME "${PROJECT}Python" CACHE STRING "Basename for python module.")
  endif()

  set(MYPROJECT_PYTHON_SRCS)

  if (BUILD_OpenCV)
    list(APPEND MYPROJECT_PYTHON_SRCS mpLibPythonWithOpenCV.cpp) #Rename as appropriate.
    message("Including pyboostcvconverter, thanks to Gregory Kramida.")

    execute_process(
      COMMAND "${PYTHON_EXECUTABLE}" -c
              "from __future__ import print_function\ntry: import numpy; print(numpy.get_include(), end='')\nexcept:pass\n"
              OUTPUT_VARIABLE NumPy_INCLUDE_DIR)
    execute_process(
      COMMAND "${PYTHON_EXECUTABLE}" -c
              "from __future__ import print_function\ntry: import numpy; print(numpy.__version__, end='')\nexcept:pass\n"
      OUTPUT_VARIABLE NumPy_VERSION)
    message("Found NumPy_INCLUDE_DIR=${NumPy_INCLUDE_DIR}, NumPy_VERSION=${NumPy_VERSION}")
    include_directories(${NumPy_INCLUDE_DIR})
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/pyboostcvconverter/include)
    list(APPEND MYPROJECT_PYTHON_SRCS pyboostcvconverter/src/pyboost_cv3_converter.cpp)
  else()
    list(APPEND MYPROJECT_PYTHON_SRCS mpLibPython.cpp) # Rename as appropriate.
  endif()

  link_libraries(${ALL_LIBRARIES})
  PYTHON_ADD_MODULE(${MYPROJECT_PYTHON_MODULE_NAME} ${MYPROJECT_PYTHON_SRCS})
  if(APPLE)
    set_target_properties(${MYPROJECT_PYTHON_MODULE_NAME} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
  endif()
  install(TARGETS ${MYPROJECT_PYTHON_MODULE_NAME} DESTINATION ${MYPROJECT_INSTALL_LIB_DIR})

endif()
