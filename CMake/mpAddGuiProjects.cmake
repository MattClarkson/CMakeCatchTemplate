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

# Todo: Make macro to simplify this config.

option(BUILD_QtVTKDemo "Build QtVTKDemo Gui." OFF)
option(BUILD_QMLDemo "Build QMLDemo Gui." OFF)
option(BUILD_QOpenGLDemo "Build QOpenGLDemo Gui." OFF)
option(BUILD_QMLVLDemo "(not finished) Build QML with VL Demo Gui." OFF)
mark_as_advanced(BUILD_QMLVLDemo)

if(BUILD_PYTHON_BINDINGS AND BUILD_QtVTKDemo)
  set(BUILD_QtVTKDemo OFF CACHE BOOL "Build QtVTKDemo Gui." FORCE)
  message("Forcing BUILD_QtVTKDemo to OFF as you want a python module.")
endif()

if(BUILD_PYTHON_BINDINGS AND BUILD_QMLDemo)
  set(BUILD_QMLDemo OFF CACHE BOOL "Build QMLDemo Gui." FORCE)
  message("Forcing BUILD_QMLDemo to OFF as you want a python module.")
endif()

if(BUILD_PYTHON_BINDINGS AND BUILD_QOpenGLDemo)
  set(BUILD_QOpenGLDemo OFF CACHE BOOL "Build QOpenGLDemo Gui." FORCE)
  message("Forcing BUILD_QOpenGLDemo to OFF as you want a python module.")
endif()

if(BUILD_PYTHON_BINDINGS AND BUILD_QMLVLDemo)
  set(BUILD_QMLVLDemo OFF CACHE BOOL "Build QML with VL Demo Gui." FORCE)
  message("Forcing BUILD_QMLVLDemo to OFF as you want a python module.")
endif()

option(MYPROJECT_USE_QT "Use Qt." OFF)
mark_as_advanced(MYPROJECT_USE_QT) # Qt gets baked into VTK, so really developers should not fiddle with this.

if(BUILD_QtVTKDemo AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QtVTKDemo being ON.")
endif()

if(BUILD_QtVTKDemo AND NOT BUILD_VTK)
  set(BUILD_VTK ON CACHE BOOL "Build VTK." FORCE)
  message("Forcing BUILD_VTK to ON due to BUILD_QtVTKDemo being ON.")
endif()

if(BUILD_QMLDemo AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QMLDemo being ON.")
endif()

if(BUILD_QMLDemo AND NOT BUILD_SHARED_LIBS)
  message("Forcing BUILD_SHARED_LIBS to ON due to BUILD_QMLDEMO being ON.")
  set(BUILD_SHARED_LIBS ON CACHE BOOL "Build Shared Libraries" FORCE)
endif()

if(BUILD_QMLVLDemo AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QMLVLDemo being ON.")
endif()

if(BUILD_QMLVLDemo AND NOT BUILD_SHARED_LIBS)
  message("Forcing BUILD_SHARED_LIBS to ON due to BUILD_QMLVLDemo being ON.")
  set(BUILD_SHARED_LIBS ON CACHE BOOL "Build Shared Libraries" FORCE)
endif()

if(BUILD_QMLVLDemo AND NOT BUILD_VL)
  message("Forcing BUILD_VL to ON due to BUILD_VL being ON.")
  set(BUILD_VL ON CACHE BOOL "Build VL" FORCE)
endif()

if(BUILD_QOpenGLDemo AND NOT MYPROJECT_USE_QT)
  set(MYPROJECT_USE_QT ON CACHE BOOL "Use Qt." FORCE)
  message("Forcing MYPROJECT_USE_QT to ON due to BUILD_QOpenGLDemo being ON.")
endif()

######################################################################
# This is a list of all known GUI apps. Used for things like
# creating Mac OSX bundles, and each command line app gets copied
# into each OSX bundle.
######################################################################
if (BUILD_QtVTKDemo)
  list(APPEND _known_apps QtVTKDemo)
  set(BUILDING_GUIS ON)
endif()
if (BUILD_QMLDemo)
  list(APPEND _known_apps QMLDemo)
  set(BUILDING_GUIS ON)
endif()
if (BUILD_QOpenGLDemo)
  list(APPEND _known_apps QOpenGLDemo)
  set(BUILDING_GUIS ON)
endif()
if (BUILD_QMLVLDemo)
  list(APPEND _known_apps QMLVLDemo)
  set(BUILDING_GUIS ON)
endif()
set_property(GLOBAL PROPERTY MYPROJECT_GUI_APPS ${_known_apps})
