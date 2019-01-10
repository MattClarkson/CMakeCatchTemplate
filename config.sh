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

function pre_build {
  echo "Starting pre_build."

  if [ -n "$IS_OSX" ]; then
    echo "pre_build is on Mac, no additional dependencies at the moment."
  else
    echo "pre_build is on Linux. To Do. Fix additional dependencies."

    # Note: Most of these were deduced while testing various combinations of VTK, PCL, OpenCV.
    # You may be able to get away with a much smaller list, depending on your actual testing requirements.
    #sudo apt-get update
    #sudo apt-get -yqq install freeglut3
    #sudo apt-get -yqq install freeglut3-dev
    #sudo apt-get -yqq install binutils-gold
    #sudo apt-get -yqq install libglew-dev
    #sudo apt-get -yqq install mesa-common-dev
    #sudo apt-get -yqq install build-essential
    #sudo apt-get -yqq install libglew1.5-dev
    #sudo apt-get -yqq install libglm-dev
    #sudo apt-get -yqq install mesa-utils-extra
    #sudo apt-get -yqq install libgl1-mesa-dev
    #sudo apt-get -yqq install libglapi-mesa
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
  echo "Finished pre_build."
}

function run_tests {
  echo "Starting run_tests."
  echo "Nothing to do as yet."
  echo "Finished run_tests."
}

function build_wheel {
  echo "Starting build_wheel: $@"
  echo "REPO_DIR=$REPO_DIR"
  echo "PLAT=$PLAT"
  echo "DO_PYTHON_BUILD=$DO_PYTHON_BUILD"
  pwd
  if [ "${DO_PYTHON_BUILD}" = "true" ]; then
    build_bdist_wheel $@
    echo "Checking dist folder."
    pwd
    ls -lrt dist/
  else
    echo "Skipping build_bdist_wheel."
  fi
  echo "Finished build_wheel."
}