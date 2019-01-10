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
  if [ -n "$IS_OSX" ]; then
    echo "Running pre_build for Mac."
  else
    # Note: Most of these were deduced while testing various combinations of VTK, PCL, OpenCV.
    # You may be able to get away with a much smaller list, depending on your actual testing requirements.
    sudo apt-get update
    sudo apt-get -yqq install freeglut3
    sudo apt-get -yqq install freeglut3-dev
    sudo apt-get -yqq install binutils-gold
    sudo apt-get -yqq install libglew-dev
    sudo apt-get -yqq install mesa-common-dev
    sudo apt-get -yqq install build-essential
    sudo apt-get -yqq install libglew1.5-dev
    sudo apt-get -yqq install libglm-dev
    sudo apt-get -yqq install mesa-utils-extra
    sudo apt-get -yqq install libgl1-mesa-dev
    sudo apt-get -yqq install libglapi-mesa
  fi

  pwd
  python --version
  cmake --version
  mkdir build
  cd build
  cmake -DBUILD_SUPERBUILD:BOOL=ON -DBUILD_TESTING:BOOL=ON -DBUILD_Boost:BOOL=ON -DBUILD_Python_Boost:BOOL=ON -DBUILD_Eigen:BOOL=OFF -DBUILD_glog:BOOL=OFF -DBUILD_gflags:BOOL=OFF -DBUILD_VTK:BOOL=OFF -DBUILD_PCL:BOOL=OFF -DBUILD_OpenCV:BOOL=OFF ..
  make
  cd MYPROJECT-build
  ctest .
  cd ../../
}

function run_tests {
  # Runs python tests on installed distribution from an empty directory.
  :
}

function build_wheel {
  echo "Starting build_wheel"
  pwd
  python setup.py bdist_wheel
  echo "Finished build_wheel"
}