/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "mpOpenGLMainWindow.h"
#include "mpOpenGLWidget.h"

namespace mp
{

//-----------------------------------------------------------------------------
OpenGLMainWindow::OpenGLMainWindow()
{
  m_Widget = new OpenGLWidget;
  this->setCentralWidget(m_Widget);
  this->setWindowTitle(tr("OpenGLMainWindow"));
}

} // end namespace
