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

# Install all Qt qml infrastructure.
# Note: Im trying to install everything under the bin/qml folder EXCEPT QtTest.
#       Im sure there's a nicer way of doing it using the QtQuickCompiler or something.
set(_qml_dest_dir bin/qml)
if(APPLE)
  set(_qml_dest_dir ${APP_NAME}.app/Contents/MacOS/qml)
endif()
foreach (d
  Enginio
  Qt
  Qt3D
  QtAudioEngine
  QtBluetooth
  QtCanvas3D
  QtGraphicalEffects
  QtLocation
  QtMultimedia
  QtNfc
  QtPositioning
  QtQml
  QtQuick
  QtQuick.2
  QtSensors
  QtWebChannel
  QtWebEngine
  QtWebSockets
  QtWebView
  )
  install(DIRECTORY ${Qt5_DIR}/../../../qml/${d} DESTINATION ${_qml_dest_dir})
endforeach()
install(FILES ${Qt5_DIR}/../../../qml/builtins.qmltypes DESTINATION ${_qml_dest_dir})

# Now compile in our own qml files into the resource filesystem.
qt5_add_resources(QML_QRC View/qml.qrc)
add_executable(${APP_NAME} MACOSX_BUNDLE ${QML_QRC} App/main.cpp)

# Add libraries here if necessary.
set(APP_LIBS)
target_link_libraries(${APP_NAME} ${APP_LIBS} ${QT5_LINK_LIBRARIES})

# This sorts out the fixup_bundle.
mpCreateGuiApplication(${APP_NAME} "${ADDITIONAL_SEARCH_PATHS}")
