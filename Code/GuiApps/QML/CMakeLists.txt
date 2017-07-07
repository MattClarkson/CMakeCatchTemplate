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

set(APP_NAME QML)
get_property(_apps GLOBAL PROPERTY MYPROJECT_APPS)
list(APPEND _apps ${APP_NAME})
set_property(GLOBAL PROPERTY MYPROJECT_APPS ${_apps})

qt5_add_resources(QML_QRC View/qml.qrc)

add_executable(${APP_NAME} MACOSX_BUNDLE
  ${QML_QRC}
  App/main.cpp
)

set(APP_LIBS
)

set(_plugin_dest_dir bin)
if(APPLE)
  set(_plugin_dest_dir bin/${APP_NAME}.app/Contents/MacOS)
endif()
file(GLOB QML_FILES **/*.qml)
foreach(_qml_file ${QML_FILES})
  get_filename_component(_file ${_qml_file} NAME)
  configure_file(${_qml_file} "${CMAKE_BINARY_DIR}/${_plugin_dest_dir}/${_file}")
endforeach()
MYPROJECT_INSTALL(PROGRAMS ${QML_FILES})

target_link_libraries(${APP_NAME} ${APP_LIBS} ${QT5_LINK_LIBRARIES})
mpCreateGuiApplication(${APP_NAME} ${ADDITIONAL_SEARCH_PATHS})
