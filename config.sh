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

# Define custom utilities
# Test for macOS with [ -n "$IS_OSX" ]

function pre_build {
  # Any stuff that you need to do before you start building the wheels
  # Runs in the root directory of this repository.
  pwd
  python --version
  cmake --version
  cmake -DBUILD_SUPERBUILD:BOOL=ON -DBUILD_TESTING:BOOL=ON -DBUILD_Boost:BOOL=ON -DBUILD_Python_Boost:BOOL=ON -DBUILD_Eigen:BOOL=OFF -DBUILD_glog:BOOL=OFF -DBUILD_gflags:BOOL=OFF -DBUILD_VTK:BOOL=OFF -DBUILD_PCL:BOOL=OFF -DBUILD_OpenCV:BOOL=OFF ..
  make
  cd MYPROJECT-build
  ctest .
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  :
}

