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
get_property(_apps GLOBAL PROPERTY MYPROJECT_APPS)
list(APPEND _apps ${APP_NAME})
set_property(GLOBAL PROPERTY MYPROJECT_APPS ${_apps})

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

set(plugin_dest_dir bin)
set(qtconf_dest_dir bin)
set(APPS "\${CMAKE_INSTALL_PREFIX}/bin/${APP_NAME}")
if(APPLE)
  set(plugin_dest_dir ${APP_NAME}.app/Contents/MacOS)
  set(qtconf_dest_dir ${APP_NAME}.app/Contents/Resources)
  set(APPS "\${CMAKE_INSTALL_PREFIX}/${APP_NAME}.app")
endif()
if(WIN32)
  set(APPS "\${CMAKE_INSTALL_PREFIX}/bin/${APP_NAME}.exe")
endif()

install(TARGETS ${APP_NAME}
        BUNDLE DESTINATION . COMPONENT Runtime
        RUNTIME DESTINATION bin COMPONENT Runtime
       )

set(_qt_conf_plugin_install_prefix .)
if(APPLE)
  set(_qt_conf_plugin_install_prefix ./MacOS)
endif()

install(CODE "
        file(WRITE \"\${CMAKE_INSTALL_PREFIX}/${qtconf_dest_dir}/qt.conf\" \"
[Paths]
Prefix=${_qt_conf_plugin_install_prefix}
\")" COMPONENT Runtime)


if(Qt5_DIR)
  get_property(_qmake_location TARGET ${Qt5Core_QMAKE_EXECUTABLE}
               PROPERTY IMPORT_LOCATION)
  get_filename_component(_qmake_path "${_qmake_location}" DIRECTORY)
  if(APPLE)
    install(FILES "${_qmake_path}/../plugins/platforms/libqcocoa.dylib"
            DESTINATION "${APP_NAME}.app/Contents/MacOS/platforms"
            CONFIGURATIONS Release)
  elseif(WIN32)
    install(FILES "${_qmake_path}/../plugins/platforms/qwindows.dll"
            DESTINATION "bin/plugins/platforms"
            CONFIGURATIONS Release)
  elseif(UNIX)
    install(FILES "${_qmake_path}/../plugins/platforms/libqxcb.so"
            DESTINATION "bin/plugins/platforms"
            CONFIGURATIONS Release)
  else()
    message(WARNING "Unrecognised platform, so cannot install Qt platforms.")
  endif()
endif()

install(CODE "
        file(GLOB_RECURSE QTPLUGINS
        \"\${CMAKE_INSTALL_PREFIX}/${plugin_dest_dir}/platforms/*${CMAKE_SHARED_LIBRARY_SUFFIX}\")
        include(BundleUtilities)
        fixup_bundle(\"${APPS}\" \"\${QTPLUGINS}\" \"${ADDITIONAL_SEARCH_PATHS}\")
        " COMPONENT Runtime)
