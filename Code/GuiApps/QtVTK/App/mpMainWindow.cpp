/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpMainWindow.h"
#include "mpExceptionMacro.h"

namespace mp
{

//-----------------------------------------------------------------------------
MainWindow::MainWindow(mp::ModelBackend* model)
{
  if (model == nullptr)
  {
    mpExceptionThrow() << "Model is null.";
  }
  m_Model = model;

  setupUi(this);
  setCentralWidget(m_CentralWidget);
}


//-----------------------------------------------------------------------------
MainWindow::~MainWindow()
{
}

} // end namespace
