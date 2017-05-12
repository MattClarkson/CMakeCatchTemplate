/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpCentralWidget.h"

#include <vtkActor.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkGenericOpenGLRenderWindow.h>

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


//-----------------------------------------------------------------------------
VTKViewWidget* CentralWidget::GetVTKViewWidget() const
{
  return m_VTKView;
}


//-----------------------------------------------------------------------------
void CentralWidget::AddActor(vtkActor* a)
{
  VTKViewWidget *viewer = this->GetVTKViewWidget();
}

} // end namespace
