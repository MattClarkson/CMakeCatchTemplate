/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "mpQQuickVTKView.h"
#include <vtkRendererCollection.h>

namespace mp {

//-----------------------------------------------------------------------------
QQuickVTKView::~QQuickVTKView()
{
  if (m_VTKRenderWindow)
  {
    m_VTKRenderWindowInteractor->Disable();
    m_VTKRenderWindow->SetInteractor(nullptr);
    m_VTKRenderWindow->RemoveAllObservers();
    vtkRendererCollection *c = m_VTKRenderWindow->GetRenderers();
    vtkRenderer *v = nullptr;
    while(v = c->GetNextItem(), v != nullptr)
    {
      m_VTKRenderWindow->RemoveRenderer(v);
    }
  }
}


//-----------------------------------------------------------------------------
QQuickVTKView::QQuickVTKView(QWindow * parent)
: QQuickView(parent)
, m_VTKRenderWindow(nullptr)
, m_VTKRenderWindowInteractor(nullptr)
, m_VTKInteractorStyleMultiTouchCamera(nullptr)
, m_EraseBeforeVTKRendering(true)
{
  this->Init();
}


//-----------------------------------------------------------------------------
QQuickVTKView::QQuickVTKView(QQmlEngine * engine, QWindow * parent)
: QQuickView(engine, parent)
, m_VTKRenderWindow(nullptr)
, m_VTKRenderWindowInteractor(nullptr)
, m_VTKInteractorStyleMultiTouchCamera(nullptr)
, m_EraseBeforeVTKRendering(true)
{
  this->Init();
}


//-----------------------------------------------------------------------------
QQuickVTKView::QQuickVTKView(const QUrl & source, QWindow * parent)
: QQuickView(source, parent)
, m_VTKRenderWindow(nullptr)
, m_VTKRenderWindowInteractor(nullptr)
, m_VTKInteractorStyleMultiTouchCamera(nullptr)
, m_EraseBeforeVTKRendering(true)
{
  this->Init();
}


//-----------------------------------------------------------------------------
void QQuickVTKView::Init()
{
  m_VTKRenderWindow = vtkExternalOpenGLRenderWindow::New();

  m_VTKInteractorStyleMultiTouchCamera = vtkInteractorStyleMultiTouchCamera::New();

  m_VTKRenderWindowInteractor = vtkRenderWindowInteractor::New();
  m_VTKRenderWindowInteractor->SetRenderWindow(m_VTKRenderWindow);
  m_VTKRenderWindowInteractor->SetInteractorStyle(m_VTKInteractorStyleMultiTouchCamera);

  connect(this, SIGNAL(beforeRendering()), this, SLOT(Render()), Qt::DirectConnection);
}


//-----------------------------------------------------------------------------
void QQuickVTKView::AddRenderer(vtkRenderer* r)
{
  m_VTKRenderWindow->AddRenderer(r);
}


//-----------------------------------------------------------------------------
void QQuickVTKView::RemoveRenderer(vtkRenderer *r)
{
  m_VTKRenderWindow->RemoveRenderer(r);
}


//-----------------------------------------------------------------------------
void QQuickVTKView::SetEraseBeforeVTKRendering(bool b)
{
  m_EraseBeforeVTKRendering = b;
}


//-----------------------------------------------------------------------------
void QQuickVTKView::Render()
{
  emit beforeVTKRendering();
  m_VTKRenderWindow->SetErase(m_EraseBeforeVTKRendering);
  m_VTKRenderWindow->Render();
  emit afterVTKRendering();
}


//-----------------------------------------------------------------------------
void QQuickVTKView::SetEnabled(bool isEnabled)
{
  if (isEnabled)
  {
    m_VTKRenderWindowInteractor->Enable();
  }
  else
  {
    m_VTKRenderWindowInteractor->Disable();
  }
}

} // end namespace
