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

#! \brief Extract version information from a local working copy
#!
#! If the source_dir variable points to a git repository, this function
#! extracts the current revision hash and branch/tag name.
#!
#! If the source_dir variable points to a subversion repository, this
#! function extracts the current svn revision.
#
#! The information is provided in
#! <ul>
#!  <li> ${prefix}_REVISION_ID The git hash or svn revision value
#!  <li> ${prefix}_REVISION_NAME The git branch/tag name or empty
#!  <li> ${prefix}_WC_TYPE The working copy type, one of "local", "git", or "svn"
#! </ul>
#!
#! \param source_dir The directory containing a working copy
#! \param prefix A prefix to prepend to the variables containing
#!               the extracted information.
#!
function(mitkFunctionGetVersion source_dir prefix)

  if(NOT prefix)
    message(FATAL_ERROR "prefix argument not specified")
  endif()

  # initialize variables
  set(_wc_type "local")
  set(_wc_id "")
  set(_wc_name "")


  find_package(Git)
  if(GIT_FOUND)

    GIT_IS_REPO(${source_dir} _is_git_repo)
    if(_is_git_repo)
      set(_wc_type "git")
      GIT_WC_INFO(${source_dir} ${prefix})

      set(_wc_id ${${prefix}_WC_REVISION_HASH})

      string(REPLACE " " ";" hash_name ${${prefix}_WC_REVISION_NAME})
      list(GET hash_name 1 name)
      if(name)
        set(_wc_name ${name})
      endif()
    endif()
  endif()

  # test for svn working copy
  if(_wc_type STREQUAL "local")

    find_package(Subversion)
    if(Subversion_FOUND)
      execute_process(COMMAND ${Subversion_SVN_EXECUTABLE} info
                      WORKING_DIRECTORY ${source_dir}
                      RESULT_VARIABLE _subversion_result
                      OUTPUT_QUIET
                      ERROR_QUIET)

      if(NOT _subversion_result)
        set(_wc_type svn)
        Subversion_WC_INFO(${source_dir} ${prefix})
        set(_wc_id ${${prefix}_WC_REVISION})
      endif()
    endif()

  endif()

  set(${prefix}_WC_TYPE ${_wc_type} PARENT_SCOPE)
  set(${prefix}_REVISION_ID ${_wc_id} PARENT_SCOPE)
  set(_shortid ${_wc_id})
  if(_wc_type STREQUAL "git")
    string(SUBSTRING ${_shortid} 0 7 _shortid)
  endif()
  set(${prefix}_REVISION_SHORTID ${_shortid} PARENT_SCOPE)
  set(${prefix}_REVISION_NAME ${_wc_name} PARENT_SCOPE)

  # For backwards compatibility
  set(${prefix}_WC_REVISION_HASH ${_wc_id} PARENT_SCOPE)
  set(${prefix}_WC_REVISION_NAME ${_wc_name} PARENT_SCOPE)

endfunction()
