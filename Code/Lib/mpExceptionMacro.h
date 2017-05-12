/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpExceptionMacro_h
#define mpExceptionMacro_h

#include "mpException.h"

#define mpExceptionThrow() throw mp::Exception(__FILE__,__LINE__)

#endif
