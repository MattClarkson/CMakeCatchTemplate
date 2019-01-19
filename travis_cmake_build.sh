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

function cmake_build {
  mkdir build
  cd build
  cmake -DBUILD_SUPERBUILD:BOOL=ON -DBUILD_TESTING:BOOL=ON -DBUILD_Boost:BOOL=ON -DBUILD_Python_Boost:BOOL=ON -DBUILD_Eigen:BOOL=OFF -DBUILD_glog:BOOL=OFF -DBUILD_gflags:BOOL=OFF -DBUILD_VTK:BOOL=OFF -DBUILD_PCL:BOOL=OFF -DBUILD_OpenCV:BOOL=OFF ..
  make
  cd MYPROJECT-build
  ctest .
  cd ../../
}