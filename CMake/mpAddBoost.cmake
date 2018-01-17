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

option(BUILD_Boost "Build Boost." OFF)

if(BUILD_Boost)
  list(APPEND MYPROJECT_BOOST_LIBS "filesystem")
  list(APPEND MYPROJECT_BOOST_LIBS "system")
  list(APPEND MYPROJECT_BOOST_LIBS "date_time")
  list(APPEND MYPROJECT_BOOST_LIBS "regex")
  list(APPEND MYPROJECT_BOOST_LIBS "thread")
  list(APPEND MYPROJECT_BOOST_LIBS "iostreams")
  list(APPEND MYPROJECT_BOOST_LIBS "program_options")
endif()
