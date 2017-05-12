/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpMainWindow.h"
#include <mpExceptionMacro.h>

#include <QFileDialog>

#include <cassert>

namespace mp
{

//-----------------------------------------------------------------------------
MainWindow::MainWindow(mp::VolumeRenderingModel* model)
{
  if (model == nullptr)
  {
    mpExceptionThrow() << "Model is null.";
  }
  m_Model = model;

  setupUi(this);
  setCentralWidget(m_CentralWidget);

  bool ok = false;
  ok = connect(actionOpen, SIGNAL(triggered()), this, SLOT(OnFileOpen()));
  assert(ok);
}


//-----------------------------------------------------------------------------
MainWindow::~MainWindow()
{
}


//-----------------------------------------------------------------------------
void MainWindow::OnFileOpen()
{
  QString fileName = QFileDialog::getOpenFileName(this);
  if (!fileName.isEmpty())
  {
    m_Model->LoadFile(fileName);
  }
}

} // end namespace
