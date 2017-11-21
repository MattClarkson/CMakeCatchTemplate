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

  set(_qt_conf_plugin_install_prefix "Prefix=.")
  if(APPLE)
    set(_qt_conf_plugin_install_prefix "Prefix=./MacOS")
  endif()

  set(_qt_conf_lib_prefix)
  if(NOT APPLE)
    set(_qt_conf_lib_prefix "Libraries=.")
  endif()
  install(CODE "
          file(WRITE \"\${CMAKE_INSTALL_PREFIX}/${qtconf_dest_dir}/qt.conf\" \"
  [Paths]
  ${_qt_conf_plugin_install_prefix}
  ${_qt_conf_lib_prefix}
  \")" COMPONENT Runtime)


  if(APPLE)
    set_target_properties(${APP_NAME} PROPERTIES MACOSX_BUNDLE_NAME "${APP_NAME}")
    set(icon_name "icon.icns")
    set(icon_full_path "${CMAKE_CURRENT_SOURCE_DIR}/icons/${icon_name}")
    if(EXISTS "${icon_full_path}")
      set_target_properties(${APP_NAME} PROPERTIES MACOSX_BUNDLE_ICON_FILE "${icon_name}")
      file(COPY ${icon_full_path} DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${APP_NAME}.app/Contents/Resources/")
      install(FILES ${icon_full_path} DESTINATION "${APP_NAME}.app/Contents/Resources/")
    endif()
  endif()

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
              DESTINATION "bin/platforms"
              CONFIGURATIONS Release)
    elseif(UNIX)
      install(FILES "${_qmake_path}/../plugins/platforms/libqxcb.so"
              DESTINATION "bin/platforms"
              CONFIGURATIONS Release)
    else()
      message(WARNING "Unrecognised platform, so cannot install Qt platforms.")
    endif()
  endif()

  install(CODE "
          file(GLOB_RECURSE QTPLUGINS
          \"\${CMAKE_INSTALL_PREFIX}/${plugin_dest_dir}/platforms/*${CMAKE_SHARED_LIBRARY_SUFFIX}\")
          file(GLOB_RECURSE QMLPLUGINS
          \"\${CMAKE_INSTALL_PREFIX}/${plugin_dest_dir}/qml/*${CMAKE_SHARED_LIBRARY_SUFFIX}\")
          list(APPEND QTPLUGINS \"\${QMLPLUGINS}\")
          include(BundleUtilities)
          fixup_bundle(\"${APPS}\" \"\${QTPLUGINS}\" \"${ADDITIONAL_SEARCH_PATHS}\")
          " COMPONENT Runtime)

endmacro()
