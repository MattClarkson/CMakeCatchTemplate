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

set(APP_NAME QMLDemo)
get_property(_apps GLOBAL PROPERTY MYPROJECT_APPS)
list(APPEND _apps ${APP_NAME})
set_property(GLOBAL PROPERTY MYPROJECT_APPS ${_apps})

# Install all Qt qml infrastructure.
set(_qml_dest_dir bin)
if(APPLE)
  set(_qml_dest_dir ${APP_NAME}.app/Contents/MacOS)
endif()
install(DIRECTORY ${Qt5_DIR}/../../../qml DESTINATION ${_qml_dest_dir})

# If all qml files for this project are referenced in the
# .qrc file, then they get compiled into the main executable.
qt5_add_resources(QML_QRC View/qml.qrc)
add_executable(${APP_NAME} MACOSX_BUNDLE ${QML_QRC} App/main.cpp)

# Add libraries here if necessary.
set(APP_LIBS)
target_link_libraries(${APP_NAME} ${APP_LIBS} ${QT5_LINK_LIBRARIES})

# This sorts out the fixup_bundle.
mpCreateGuiApplication(${APP_NAME} ${ADDITIONAL_SEARCH_PATHS})
