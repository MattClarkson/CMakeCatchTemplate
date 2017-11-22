#/*================================================================================
#
#  NiftyLink:  A software library to facilitate communication over OpenIGTLink.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#=================================================================================*/

set(APP_NAME QtVTKApp)

set(APP_UIS
  mpMainWindow.ui
  mpCentralWidget.ui
)

set(APP_SRCS
  mpMainWindow.cpp
  mpCentralWidget.cpp
)

set(APP_MOC_HDRS
  mpMainWindow.h
  mpCentralWidget.h
)

set(APP_HDRS
)

set(APP_RES
  Resources/QtVTK.rc
)

qt5_wrap_ui(QT5_UIS ${APP_UIS})
qt5_wrap_cpp(QT5_MOCS ${APP_MOC_HDRS})
qt5_add_resources(QT5_RES ${APP_RES})

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(${APP_NAME} MACOSX_BUNDLE
  ${APP_SRCS}
  ${APP_HDRS}
  ${QT5_UIS}
  ${QT5_MOCS}
  ${QT5_RES}
  main.cpp
)

set(APP_LIBS
  myproject
  qtvtkmodel
  qtvtkview
  qtvtkcontroller
)

target_link_libraries(${APP_NAME} ${APP_LIBS} ${ALL_THIRD_PARTY_LIBRARIES} ${QT5_LINK_LIBRARIES})
mpCreateGuiApplication(${APP_NAME} "${ADDITIONAL_SEARCH_PATHS}")
