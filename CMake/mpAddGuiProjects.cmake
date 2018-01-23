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


option(BUILD_QTVTKGUI "Build QtVTK Gui." OFF)
option(BUILD_QMLDEMO "Build QMLDemo Gui" OFF)

if(BUILD_PYTHON_BINDINGS AND BUILD_QTVTKGUI)
  set(BUILD_QTVTKGUI OFF CACHE BOOL "Build QtVTK Gui." FORCE)
  message("Forcing BUILD_QTVTKGUI to OFF as you want a python module.")
endif()

if(BUILD_PYTHON_BINDINGS AND BUILD_QMLDEMO)
  set(BUILD_QMLDEMO OFF CACHE BOOL "Build QMLDemo Gui." FORCE)
  message("Forcing BUILD_QMLDEMO to OFF as you want a python module.")
endif()

option(MYPROJECT_USE_QT "Use Qt." OFF)
mark_as_advanced(MYPROJECT_USE_QT) # Qt gets baked into VTK, so really developers should not fiddle with this.

if(BUILD_QTVTKGUI AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QTVTKGUI being ON.")
endif()

if(BUILD_QTVTKGUI AND NOT BUILD_VTK)
  set(BUILD_VTK ON CACHE BOOL "Build VTK." FORCE)
  message("Forcing BUILD_VTK to ON due to BUILD_QTVTKGUI being ON.")
endif()

if(BUILD_QMLDEMO AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QMLDEMO being ON.")
endif()

if(BUILD_QMLDEMO AND NOT BUILD_SHARED_LIBS)
  message("Forcing BUILD_SHARED_LIBS to ON due to BUILD_QMLDEMO being ON.")
  set(BUILD_SHARED_LIBS ON CACHE BOOL "Build Shared Libraries" FORCE)
endif()

######################################################################
# This is a list of all known GUI apps. Used for things like
# creating Mac OSX bundles, and each command line app gets copied
# into each OSX bundle.
######################################################################
if (BUILD_QTVTKGUI)
  list(APPEND _known_apps QtVTKApp)
  set(BUILDING_GUIS ON)
endif()
if (BUILD_QMLDEMO)
  list(APPEND _known_apps QMLDemo)
  set(BUILDING_GUIS ON)
endif()
set_property(GLOBAL PROPERTY MYPROJECT_GUI_APPS ${_known_apps})
