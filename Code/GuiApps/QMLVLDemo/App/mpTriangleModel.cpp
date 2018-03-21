/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "mpTriangleModel.h"
#include "mpVLTriangleRenderer.h"

namespace mp
{

//-----------------------------------------------------------------------------
TriangleModel::TriangleModel()
: m_Degrees(0)
, m_Renderer(nullptr)
, m_TriangleData({
                 0.0f,  0.5f, 1.0f, 0.0f, 0.0f, // Vertex 1: Red
                 0.5f, -0.5f, 0.0f, 1.0f, 0.0f, // Vertex 2: Green
                -0.5f, -0.5f, 0.0f, 0.0f, 1.0f  // Vertex 3: Blue
                 })
{
  connect(this, &QQuickItem::windowChanged, this, &TriangleModel::handleWindowChanged);
}


//-----------------------------------------------------------------------------
void TriangleModel::handleWindowChanged(QQuickWindow *win)
{
  if(window())
  {
    disconnect(window(), 0, this, 0);
  }

  if (win)
  {
    connect(win, &QQuickWindow::beforeSynchronizing, this, &TriangleModel::sync, Qt::DirectConnection);
    connect(win, &QQuickWindow::sceneGraphInvalidated, this, &TriangleModel::cleanup, Qt::DirectConnection);

    // If we allow QML to do the clearing, they would
    // clear what we paint and nothing would show.
    win->setClearBeforeRendering(false);
  }
}


//-----------------------------------------------------------------------------
void TriangleModel::setDegrees(qreal d)
{
  if (d == m_Degrees)
  {
    return;
  }
  m_Degrees = d;
  emit degreesChanged();
  if (window())
  {
    window()->update(); // presumably queues a request until the next rendering pass.
  }
}


//-----------------------------------------------------------------------------
void TriangleModel::cleanup()
{
  if (m_Renderer)
  {
    delete m_Renderer;
    m_Renderer = nullptr;
  }
}


//-----------------------------------------------------------------------------
void TriangleModel::sync()
{
  if (!m_Renderer)
  {
    m_Renderer = new VLTriangleRenderer();
    m_Renderer->setTriangleData(&m_TriangleData);
    connect(window(), &QQuickWindow::beforeRendering, m_Renderer, &VLTriangleRenderer::paint, Qt::DirectConnection);
  }
  m_Renderer->setDegrees(m_Degrees);
  m_Renderer->setViewportSize(window()->size() * window()->devicePixelRatio());
  m_Renderer->setWindow(window());
}

} // end namespace
