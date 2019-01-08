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

  set(MYPROJECT_UNITY_NAME ${MYPROJECT_LIBRARY_NAME}Unity)

  set(MYPROJECT_UNITY_SRCS
    mpUnityWrapper.cpp
  )

  set(MYPROJECT_UNITY_HDRS
    mpUnityWrapper.h
  )

  # Thanks to: https://stackoverflow.com/questions/15120951/generating-a-bundle-file-with-cmake-on-mac-osx?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  add_library(${MYPROJECT_UNITY_NAME} MODULE ${MYPROJECT_UNITY_HDRS} ${MYPROJECT_UNITY_SRCS})
  if(APPLE)
    set_target_properties(${MYPROJECT_UNITY_NAME} PROPERTIES BUNDLE TRUE)
  endif()

  target_link_libraries(${MYPROJECT_UNITY_NAME} PRIVATE ${MYPROJECT_LIBRARIES} ${ALL_THIRD_PARTY_LIBRARIES})
  install(TARGETS ${MYPROJECT_UNITY_NAME} DESTINATION ${MYPROJECT_INSTALL_LIB_DIR})

  if( NOT "${MYPROJECT_UNITY_PLUGIN_DIR}" STREQUAL "")
    install(TARGETS ${MYPROJECT_UNITY_NAME} DESTINATION ${MYPROJECT_UNITY_PLUGIN_DIR})
  endif()

endif()
