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

set(MYPROJECT_LIBRARY_NAME myproject)

set(MYPROJECT_LIBRARY_SRCS
  mpBasicTypes.cpp
  mpMyFunctions.cpp
  mpException.cpp
)

set(MYPROJECT_LIBRARY_HDRS
  mpExceptionMacro.h
)

add_library(${MYPROJECT_LIBRARY_NAME} ${MYPROJECT_LIBRARY_HDRS} ${MYPROJECT_LIBRARY_SRCS})

if(BUILD_SHARED_LIBS)
  if(WIN32)
    add_definitions(-DMYPROJECT_WINDOWS_EXPORT)
  endif(WIN32)
endif(BUILD_SHARED_LIBS)

target_link_libraries(${MYPROJECT_LIBRARY_NAME} PRIVATE ${ALL_THIRD_PARTY_LIBRARIES})

MYPROJECT_INSTALL_HEADERS()
MYPROJECT_INSTALL_LIBRARY(${MYPROJECT_LIBRARY_NAME})

if(BUILD_PYTHON_BINDINGS)
  add_subdirectory(PythonBinding)
endif()

if(BUILD_UNITY_WRAPPER)
  add_subdirectory(UnityWrapper)
endif()
