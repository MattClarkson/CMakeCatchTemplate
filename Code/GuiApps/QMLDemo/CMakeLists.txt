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
set(_qml_source_dir ${Qt5_DIR}/../../../qml)
set(_qml_dest_dir bin/qml)
if(APPLE)
  set(_qml_dest_dir ${APP_NAME}.app/Contents/MacOS/qml)
endif()
file(GLOB children RELATIVE ${_qml_source_dir} ${_qml_source_dir}/*)
foreach( c ${children})
  if( NOT ("QtTest" STREQUAL "${c}" ) )
    if( IS_DIRECTORY ${_qml_source_dir}/${c} )
      install(DIRECTORY ${_qml_source_dir}/${c} DESTINATION ${_qml_dest_dir})
    else()
      install(FILES ${_qml_source_dir}/${c} DESTINATION ${_qml_dest_dir})
    endif()
  endif()
endforeach()

# Add any additional icons/resources, that are nothing to do with QML.
set(APP_RES
  Resources/QMLDemo.rc
)
qt5_add_resources(QT5_RES ${APP_RES})

# Now compile in our QML files into the resource filesystem.
qt5_add_resources(QT5_QML View/qml.qrc)
add_executable(${APP_NAME} MACOSX_BUNDLE ${QT5_RES} ${QT5_QML} App/main.cpp)

# Add libraries here if necessary.
set(APP_LIBS)
target_link_libraries(${APP_NAME} ${APP_LIBS} ${QT5_LINK_LIBRARIES})

# This sorts out the fixup_bundle.
mpMacroCreateGuiApplication(${APP_NAME} "${ADDITIONAL_SEARCH_PATHS}")
