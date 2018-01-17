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

configure_file(${CMAKE_SOURCE_DIR}/UseMyProject.cmake.in ${CMAKE_BINARY_DIR}/UseMyProject.cmake @ONLY IMMEDIATE)
configure_file(${CMAKE_SOURCE_DIR}/MyProjectConfig.cmake.in ${CMAKE_BINARY_DIR}/MyProjectConfig.cmake @ONLY IMMEDIATE)
if(NOT BUILDING_GUIS)
  install(FILES ${CMAKE_BINARY_DIR}/UseMyProject.cmake DESTINATION . COMPONENT CONFIG)
  install(FILES ${CMAKE_BINARY_DIR}/MyProjectConfig.cmake DESTINATION . COMPONENT CONFIG)
endif()
