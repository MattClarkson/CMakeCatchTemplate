/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include <pybind11/pybind11.h>
#include "mpMyFunctions.h"
#include "docstrings.h"

// The name of the module should match that in CMakeLists.txt
PYBIND11_MODULE(CMakeCatchTemplatePython, m)
{
  m.doc() = "pybind11 example wrapping mp::MyFirstAddFunction";
  m.def("my_first_add_function", &mp::MyFirstAddFunction, add_numbers_docstring);
}
