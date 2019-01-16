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
    #sudo apt-get -yqq install build-essential
    #sudo apt-get -yqq install binutils-gold
    #sudo apt-get -yqq install freeglut3
    #sudo apt-get -yqq install freeglut3-dev
    #sudo apt-get -yqq install libglew-dev
    #sudo apt-get -yqq install libglew1.5-dev
    #sudo apt-get -yqq install libglm-dev
    #sudo apt-get -yqq install mesa-common-dev
    #sudo apt-get -yqq install mesa-utils-extra
    #sudo apt-get -yqq install libgl1-mesa-dev
    #sudo apt-get -yqq install libglapi-mesa

    # Note also. Look in .travis.yml. Decide if you are setting DO_PYTHON_BUILD to true.
    # If you are, then such commands as above should either be
    # Debian based: sudo apt-get ...
    # Centos based: sudo yum ...
    sudo yum install -y cmake3
    
  fi

  # Debug info.
  pwd
  python --version
  cmake --version

  # Run the actual C++ build.
  source ci_cmake_build.sh
  cmake_build

  echo "Finished pre_build."
}


function run_tests {
  echo "Starting run_tests."
  echo "Nothing to do as yet. You could run some python tests on your wheel perhaps?"
  echo "Finished run_tests."
}
