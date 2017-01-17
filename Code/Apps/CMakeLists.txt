#/*============================================================================
#
#  MyProject: A software package for camera calibration.
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
set(MYPROJECT_APPS
  mpMyFirstApp
)
foreach(app ${MYPROJECT_APPS})
  add_executable(${app} ${app}.cpp)
  target_link_libraries(${app} myproject ${ALL_THIRD_PARTY_LIBRARIES})
endforeach()
