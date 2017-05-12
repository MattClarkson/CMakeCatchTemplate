/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpMainWindow.h"

#include <stdexcept>

namespace mp
{

//-----------------------------------------------------------------------------
MainWindow::MainWindow(mp::ModelBackend* model)
{
  if (model == nullptr)
  {
    throw std::invalid_argument("Model is null.");
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
