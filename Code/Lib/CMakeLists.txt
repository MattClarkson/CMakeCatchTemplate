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

set(MYPROJECT_SRCS
  mpBasicTypes.cpp
  mpMyFunctions.cpp
  mpException.cpp
)

set(MYPROJECT_HDRS
  mpExceptionMacro.h
)

add_library(myproject ${MYPROJECT_SRCS})

if(BUILD_SHARED_LIBS)
  if(WIN32)
    add_definitions(-DMYPROJECT_WINDOWS_EXPORT)
  endif(WIN32)
  MYPROJECT_INSTALL(TARGETS myproject)
endif(BUILD_SHARED_LIBS)

target_link_libraries(myproject PRIVATE ${ALL_THIRD_PARTY_LIBRARIES})