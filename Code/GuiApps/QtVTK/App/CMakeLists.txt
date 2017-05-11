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
)

set(APP_SRCS
  mpMainWindow.cpp
)

set(APP_MOC_HDRS
  mpMainWindow.h
)

set(APP_HDRS
)

set(APP_RES
)

qt5_wrap_ui(QT5_UIS ${APP_UIS})
qt5_wrap_cpp(QT5_MOCS ${APP_MOC_HDRS})
qt5_add_resources(QT5_RES ${APP_RES})

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(${APP_NAME} main.cpp ${APP_SRCS} ${APP_HDRS} ${QT5_UIS} ${QT5_MOCS} ${QT5_RES})

set(APP_LIBS
  ${QT5_LINK_LIBRARIES}
)

target_link_libraries(${APP_NAME} ${APP_LIBS})
