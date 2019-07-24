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

######################################################################
# Setting build name based on local system details
######################################################################

include(mitkFunctionGetVersion)
include(niftkMacroGetGitDateTime)
include(niftkMacroGetGitBranch)

mitkFunctionGetVersion(${CMAKE_SOURCE_DIR} MYPROJECT)
niftkMacroGetGitDateTime(${CMAKE_SOURCE_DIR} MYPROJECT)
niftkMacroGetGitBranch(${CMAKE_SOURCE_DIR} MYPROJECT)

if(CMAKE_GENERATOR MATCHES Make AND NOT (CMAKE_GENERATOR MATCHES NMake) )

  find_program(UNAME NAMES uname)
  mark_as_advanced(UNAME)

  macro(getuname name flag)
    exec_program("${UNAME}" ARGS "${flag}" OUTPUT_VARIABLE "${name}")
  endmacro(getuname)

  getuname(osname -s)
  getuname(cpu    -m)

  if (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
    set(CompilerName "gcc")
  elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
    set(CompilerName "clang")
  else()
    set(CompilerName "${CMAKE_CXX_COMPILER_ID}")
  endif()

  set(CTBN "${osname}-${cpu}-${CompilerName}-${CMAKE_CXX_COMPILER_VERSION}-${MYPROJECT_BRANCH_NAME}-${MYPROJECT_REVISION_SHORTID}")

else()

  set(CTBN "${CMAKE_GENERATOR}-${MYPROJECT_BRANCH_NAME}-${MYPROJECT_REVISION_SHORTID}")

endif()

# append a short release/debug tag, so we know which one is which on the dashboard.
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(CTBN "${CTBN}-Dbg")
else()
if (CMAKE_BUILD_TYPE STREQUAL "Release")
  set(CTBN "${CTBN}-Rel")
else()
  # this should not happen. further above we check for Debug and Release and fail if it's neither.
  set(CTBN "${CTBN}-${CMAKE_BUILD_TYPE}")
endif()
endif()

string(REPLACE "\n" "" CTBN ${CTBN})
set(BUILDNAME ${CTBN} CACHE STRING "${CTBN}" FORCE)
set(CTEST_BUILD_NAME ${CTBN} CACHE STRING "${CTBN}" FORCE)
mark_as_advanced(BUILDNAME)
mark_as_advanced(CTEST_BUILD_NAME)

message(STATUS "scikit-surgeryopencvcpp branch=${MYPROJECT_BRANCH_NAME}")
message(STATUS "scikit-surgeryopencvcpp version=${MYPROJECT_REVISION_SHORTID}")
message(STATUS "scikit-surgeryopencvcpp date=${MYPROJECT_DATE_TIME}")
message(STATUS "scikit-surgeryopencvcpp ctest-name=${CTEST_BUILD_NAME}")
message(STATUS "scikit-surgeryopencvcpp build-name=${BUILDNAME}")

######################################################################
# Configure Dart testing support.  This should be done before any
# message(FATAL_ERROR ...) commands are invoked.
######################################################################

include(${CMAKE_ROOT}/Modules/Dart.cmake)
mark_as_advanced(TCL_TCLSH DART_ROOT)

enable_testing()

if(BUILD_TESTING)
  set(BUILDNAME "MYPROJECT" CACHE STRING "Name of build on the dashboard")
  mark_as_advanced(BUILDNAME)
  configure_file(CMake/CTestCustom.cmake.in ${CMAKE_BINARY_DIR}/CTestCustom.cmake @ONLY)
  configure_file(CMake/CTestContinuous.cmake.in ${CMAKE_BINARY_DIR}/CTestContinuous.cmake @ONLY)
endif(BUILD_TESTING)
