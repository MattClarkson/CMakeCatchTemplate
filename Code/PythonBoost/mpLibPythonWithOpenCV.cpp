/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

/*=============================================================================

  Derived from pyboostcvconverter by Gregory Kramida.
  See full package, as a git submodule in ./pyboostcvconverter.

=============================================================================*/
#define PY_ARRAY_UNIQUE_SYMBOL pbcvt_ARRAY_API

#include <boost/python.hpp>
#include <pyboostcvconverter/pyboostcvconverter.hpp>

namespace mp {

cv::Mat increment_elements_by_one(cv::Mat matrix)
{
  matrix += 1.0;
  return matrix;
}

#if (PY_VERSION_HEX >= 0x03000000)
static void *init_ar() {
#else
static void init_ar(){
#endif
  Py_Initialize();
  import_array();
  return NUMPY_IMPORT_ARRAY_RETVAL;
}

// The name of the module should match that in CMakeLists.txt
BOOST_PYTHON_MODULE (CMakeCatchTemplatePython) {
  init_ar();

  boost::python::to_python_converter<cv::Mat, pbcvt::matToNDArrayBoostConverter>();
  pbcvt::matFromNDArrayBoostConverter();

  boost::python::def("increment_elements_by_one", increment_elements_by_one);
}

}  // end namespace mp
