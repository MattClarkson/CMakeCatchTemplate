/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#define BOOST_PYTHON_STATIC_LIB
#include <boost/python.hpp>
#include "mpMyFunctions.h"

// The name of the module should match that in CMakeLists.txt
BOOST_PYTHON_MODULE(CMakeCatchTemplatePython)
{
  boost::python::def("my_first_add_function", mp::MyFirstAddFunction);
}
