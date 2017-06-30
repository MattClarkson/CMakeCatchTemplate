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

macro(MYPROJECT_INSTALL)

  set(ARGS ${ARGN})

  set(install_directories "")
  list(FIND ARGS DESTINATION _destination_index)

  if(_destination_index GREATER -1)
    message(SEND_ERROR "MITK_INSTALL macro must not be called with a DESTINATION parameter.")
  else()
    get_property(_apps GLOBAL PROPERTY MYPROJECT_APPS)
    if(NOT APPLE)
      install(${ARGS} DESTINATION bin)
    else()
      foreach(app ${_apps})
        install(${ARGS} DESTINATION ${app}.app/Contents/MacOS/)
      endforeach()
    endif()
  endif()

endmacro()
