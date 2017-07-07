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

macro(mpCreateGuiApplication APP_NAME ADDITIONAL_SEARCH_PATHS)
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


endmacro()
