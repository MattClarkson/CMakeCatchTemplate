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

if(BUILD_Docs)
  find_package(Doxygen REQUIRED)
  configure_file(${CMAKE_SOURCE_DIR}/Utilities/Doxygen/myprojectdoxygen.pl.in ${CMAKE_BINARY_DIR}/myprojectdoxygen.pl)

  # See comment in mpAddDocs.cmake.
  set(MYPROJECT_TAGFILES "")
  foreach( f ${MYPROJECT_EXTERNAL_DOXYGEN_TAGFILES})
    # Converts list to space separated sting, for substitution into doxygen.config.
    set(MYPROJECT_TAGFILES "${f} ${MYPROJECT_TAGFILES}")
  endforeach()

  configure_file(${CMAKE_SOURCE_DIR}/Utilities/Doxygen/doxygen.config.in ${CMAKE_BINARY_DIR}/doxygen.config)
  add_custom_target(docs ALL
    ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/doxygen.config
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" VERBATIM
  )
endif()
