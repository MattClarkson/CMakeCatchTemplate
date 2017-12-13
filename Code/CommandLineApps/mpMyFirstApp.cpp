/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include <mpMyFunctions.h>
#include <iostream>

#ifdef BUILD_gflags
#include "gflags/gflags.h"
#endif

#ifdef BUILD_glog
#include <glog/logging.h>
#endif

#ifdef BUILD_Eigen
#include <Eigen/Dense>
#include <unsupported/Eigen/NonLinearOptimization>
#endif

#ifdef BUILD_Boost
#include <boost/math/special_functions/round.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/filesystem/path.hpp>
#endif

#ifdef BUILD_OpenCV
#include <cv.h>
#endif

#ifdef BUILD_PCL
#include <pcl/point_types.h>
#include <pcl/common/projection_matrix.h>
#endif

/**
 * \brief Demo file to check that #includes and library linkage is correct.
 */
int main(int argc, char** argv)
{

#ifdef BUILD_glog
  google::InitGoogleLogging(argv[0]);
#endif

#ifdef BUILD_gflags
  gflags::SetVersionString("1.0.0");
#endif

#ifdef BUILD_Eigen
  Eigen::MatrixXd m(2,2);
  std::cout << "Printing 2x2 matrix ..." << m << std::endl;
#endif

#ifdef BUILD_Boost
  std::cout << "Rounding to ... " << boost::math::round(0.123) << std::endl;
  boost::posix_time::ptime startTime = boost::posix_time::second_clock::local_time();
  boost::filesystem::path pathname( "/tmp/tmp.txt" );
#endif

#ifdef BUILD_OpenCV
  cv::Matx44d matrix = cv::Matx44d::eye();
  std::cout << "Printing 4x4 matrix ..." << matrix << std::endl;
#endif

#ifdef BUILD_PCL
  pcl::PointCloud<pcl::PointXYZ> cloud;
#endif

  std::cout << "Calculating ... " << mp::MyFirstAddFunction(1, 2) << std::endl;
  return 0;
}
