/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpVTKViewWidget.h"

#include <cassert>

namespace mp
{

//-----------------------------------------------------------------------------
VTKViewWidget::VTKViewWidget(QWidget* parent)
: QVTKWidget2(parent)
{
}


//-----------------------------------------------------------------------------
VTKViewWidget::~VTKViewWidget()
{
}

} // end namespace
