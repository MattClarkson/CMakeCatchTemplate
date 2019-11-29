/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "catch.hpp"
#include "mpCatchMain.h"
#include "mpMyFunctions.h"
#include <iostream>
#include <vector>

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
#include <opencv2/core/core_c.h>
#ifdef MYPROJECT_USE_CUDA
#include <opencv2/core/cuda.hpp>
#endif
#endif

#ifdef BUILD_PCL
#include <pcl/point_types.h>
#include <pcl/common/projection_matrix.h>
#endif

#ifdef BUILD_ArrayFire
#include <arrayfire.h>
#endif

TEST_CASE("My first test", "[some group identifier]")
{
  int a = 5;
  REQUIRE(a < 6);
}

TEST_CASE("My second test", "[some group identifier]")
{
  std::vector<int> a;
  REQUIRE(a.size() == 0);
}

TEST_CASE("Simple add", "[MyFirstAddFunction]")
{
  REQUIRE(mp::MyFirstAddFunction(1, 2) == 3);
}

TEST_CASE("Boost test", "[Boost]")
{
#ifdef BUILD_Boost
  REQUIRE(boost::math::round(0.1) == 0);
#endif
}

TEST_CASE("Eigen test", "[Eigen]")
{
#ifdef BUILD_Eigen
  Eigen::Matrix4d mat = Eigen::Matrix4d.Identity();
  REQUIRE(mat.determinant() == 1);
#endif
}

TEST_CASE("OpenCV test", "[OpenCV")
{
#ifdef BUILD_OpenCV
  cv::Matx44d mat = cv::Matx44d::eye();
  REQUIRE(cv::determinant(mat) == 1)
}
