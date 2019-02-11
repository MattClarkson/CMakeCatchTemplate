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
  echo "Starting travis_cmake_build.sh"
  pwd
  echo "Requested python version:${PYTHON_VERSION}"
  cmake --version
  python --version
  mkdir build
  cd build
  cmake -DMYPROJECT_PYTHON_VERSION:STRING=${PYTHON_VERSION} -DBUILD_SUPERBUILD:BOOL=ON -DBUILD_TESTING:BOOL=ON -DBUILD_Boost:BOOL=ON -DBUILD_Python_Boost:BOOL=ON -DBUILD_Eigen:BOOL=OFF -DBUILD_glog:BOOL=OFF -DBUILD_gflags:BOOL=OFF -DBUILD_VTK:BOOL=OFF -DBUILD_PCL:BOOL=ON -DBUILD_OpenCV:BOOL=OFF ..
  make -j 2
  cd MYPROJECT-build
  ctest .
  cd ../../
  echo "Finished travis_cmake_build.sh"
}