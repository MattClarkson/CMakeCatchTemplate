/*=============================================================================

  MyProject: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include <mpMyFunctions.h>
#include <iostream>

#ifdef BUILD_Eigen
#include <Eigen/Dense>
#endif

#ifdef BUILD_Boost
#include <boost/math/special_functions/round.hpp>
#endif

#ifdef BUILD_OpenCV
#include <cv.h>

#endif

int main(int argc, char** argv)
{

#ifdef BUILD_Eigen
  Eigen::MatrixXd m(2,2);
  std::cout << "Printing 2x2 matrix ..." << m << std::endl;
#endif

#ifdef BUILD_Boost
  std::cout << "Rounding to ... " << boost::math::round(0.123) << std::endl;
#endif

#ifdef BUILD_OpenCV
  cv::Matx44d matrix = cv::Matx44d::eye();
  std::cout << "Printing 4x4 matrix ..." << matrix << std::endl;
#endif

  std::cout << "Calculating ... " << mp::MyFirstFunction(1) << std::endl;
  return 0;
}
