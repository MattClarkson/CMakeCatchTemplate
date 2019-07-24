# Copyright (c) 2003-2012 German Cancer Research Center,
# Division of Medical and Biological Informatics
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the
# following conditions are met:
# 
#  * Redistributions of source code must retain the above
#    copyright notice, this list of conditions and the
#    following disclaimer.
# 
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the
#    following disclaimer in the documentation and/or other
#    materials provided with the distribution.
# 
#  * Neither the name of the German Cancer Research Center,
#    nor the names of its contributors may be used to endorse
#    or promote products derived from this software without
#    specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

#
# FindGit
#

set(git_candidates git eg)

if(WIN32)
  list(APPEND git_candidates eg.cmd)
  if(NOT MSYS)
    # We don't append git.cmd, since it does not correctly return
    # exit codes, see http://code.google.com/p/msysgit/issues/detail?id=428
    list(APPEND git_candidates git.cmd)
  endif()
endif()

find_program(GIT_EXECUTABLE ${git_candidates}
  PATHS
    "C:/Program Files/Git/bin"
    "C:/Program Files (x86)/Git/bin"
  DOC "git command line client")
mark_as_advanced(GIT_EXECUTABLE)

if(GIT_EXECUTABLE)

  macro(GIT_IS_REPO dir result_var)
    # check if ${dir} is a proper Git repository
    execute_process(COMMAND ${GIT_EXECUTABLE} rev-list -n 1 HEAD
       WORKING_DIRECTORY ${dir}
       RESULT_VARIABLE GIT_error
       OUTPUT_QUIET
       ERROR_QUIET)
    if(GIT_error EQUAL 0)
      set(${result_var} 1)
    else()
      set(${result_var} 0)
    endif()
  endmacro()

  macro(GIT_WC_INFO dir prefix)
    execute_process(COMMAND ${GIT_EXECUTABLE} rev-list -n 1 HEAD
       WORKING_DIRECTORY ${dir}
       ERROR_VARIABLE GIT_error
       OUTPUT_VARIABLE ${prefix}_WC_REVISION_HASH
       OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT ${GIT_error} EQUAL 0)
      message(SEND_ERROR "Command \"${GIT_EXECUTBALE} rev-list -n 1 HEAD\" in directory ${dir} failed with output:\n${GIT_error}")
    else()
      execute_process(COMMAND ${GIT_EXECUTABLE} name-rev ${${prefix}_WC_REVISION_HASH}
         WORKING_DIRECTORY ${dir}
         OUTPUT_VARIABLE ${prefix}_WC_REVISION_NAME
          OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()

    set(${prefix}_WC_GITSVN 0)
    # In case, git-svn is used, attempt to extract svn info
    execute_process(COMMAND ${GIT_EXECUTABLE} svn info
      WORKING_DIRECTORY ${dir}
      ERROR_VARIABLE git_svn_info_error
      OUTPUT_VARIABLE ${prefix}_WC_INFO
      RESULT_VARIABLE git_svn_info_result
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    if(${git_svn_info_result} EQUAL 0)
      set(${prefix}_WC_GITSVN 1)
      string(REGEX REPLACE "^(.*\n)?URL: ([^\n]+).*"
        "\\2" ${prefix}_WC_URL "${${prefix}_WC_INFO}")
      string(REGEX REPLACE "^(.*\n)?Revision: ([^\n]+).*"
        "\\2" ${prefix}_WC_REVISION "${${prefix}_WC_INFO}")
      string(REGEX REPLACE "^(.*\n)?Last Changed Author: ([^\n]+).*"
        "\\2" ${prefix}_WC_LAST_CHANGED_AUTHOR "${${prefix}_WC_INFO}")
      string(REGEX REPLACE "^(.*\n)?Last Changed Rev: ([^\n]+).*"
        "\\2" ${prefix}_WC_LAST_CHANGED_REV "${${prefix}_WC_INFO}")
      string(REGEX REPLACE "^(.*\n)?Last Changed Date: ([^\n]+).*"
        "\\2" ${prefix}_WC_LAST_CHANGED_DATE "${${prefix}_WC_INFO}")
    endif()

  endmacro()
endif()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Git DEFAULT_MSG GIT_EXECUTABLE)
