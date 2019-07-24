#/*============================================================================
#
#  NifTK: A software platform for medical image computing.
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

macro(niftkMacroGetGitDateTime dir prefix)
  execute_process(COMMAND ${GIT_EXECUTABLE} show -s --format=%ci HEAD
       WORKING_DIRECTORY ${dir}
       ERROR_VARIABLE GIT_error
       OUTPUT_VARIABLE ${prefix}_DATE_TIME
       OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT ${GIT_error} EQUAL 0)
    message(SEND_ERROR "Command \"${GIT_EXECUTBALE} show -s --format=\"%ci\" HEAD\" in directory ${dir} failed with output:\n${GIT_error}")
  endif()
endmacro()
