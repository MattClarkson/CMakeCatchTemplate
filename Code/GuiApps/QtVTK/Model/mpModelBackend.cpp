/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpModelBackend.h"

#include <cassert>

namespace mp
{

//-----------------------------------------------------------------------------
ModelBackend::ModelBackend(QObject* parent)
: QObject(parent)
{
}


//-----------------------------------------------------------------------------
ModelBackend::~ModelBackend()
{
}

} // end namespace
