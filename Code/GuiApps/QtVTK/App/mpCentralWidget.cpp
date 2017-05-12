/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpCentralWidget.h"

namespace mp
{

//-----------------------------------------------------------------------------
CentralWidget::CentralWidget(QWidget *parent)
: QWidget(parent)
{
  setupUi(this);
}


//-----------------------------------------------------------------------------
CentralWidget::~CentralWidget()
{
}

} // end namespace
