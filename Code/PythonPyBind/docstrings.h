/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef DOCSTRINGS_H
#define DOCSTRINGS_H

using namespace std;

/* Docstrings should use C++ string literals, for easier multi line comments.
Equal indentations on each line, for Sphinx compatiblity. See
(https://pybind11.readthedocs.io/en/stable/advanced/misc.html#generating-documentation-using-sphinx)

*/

auto add_numbers_docstring = R"(
    this is a docstring.

    :param x: var
    :type x: float
    :param y: var
    :type y: float
    :return: Return a value
    :rtype: float
    )";

#endif
