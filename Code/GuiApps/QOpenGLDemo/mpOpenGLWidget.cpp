/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "mpOpenGLWidget.h"
#include <QMouseEvent>
#include <QOpenGLShaderProgram>
#include <QCoreApplication>

namespace mp
{
bool OpenGLWidget::m_Transparent = false;

//-----------------------------------------------------------------------------
OpenGLWidget::OpenGLWidget(QWidget *parent)
: QOpenGLWidget(parent)
, m_Program(nullptr)
{
  m_Core = QSurfaceFormat::defaultFormat().profile() == QSurfaceFormat::CoreProfile;
  // On systems that support it, the widget will become transparent apart from rendering.
  if (m_Transparent)
  {
    QSurfaceFormat fmt = format();
    fmt.setAlphaBufferSize(8);
    setFormat(fmt);
  }
}


//-----------------------------------------------------------------------------
OpenGLWidget::~OpenGLWidget()
{
  cleanup();
}


//-----------------------------------------------------------------------------
QSize OpenGLWidget::minimumSizeHint() const
{
  return QSize(50, 50);
}


//-----------------------------------------------------------------------------
QSize OpenGLWidget::sizeHint() const
{
  return QSize(400, 400);
}


//-----------------------------------------------------------------------------
void OpenGLWidget::cleanup()
{
  if (m_Program == nullptr)
  {
    return;
  }
  this->makeCurrent();
  delete m_Program;
  m_Program = nullptr;
  doneCurrent();
}


//-----------------------------------------------------------------------------
void OpenGLWidget::initializeGL()
{
  // In this example the widget's corresponding top-level window can change
  // several times during the widget's lifetime. Whenever this happens, the
  // QOpenGLWidget's associated context is destroyed and a new one is created.
  // Therefore we have to be prepared to clean up the resources on the
  // aboutToBeDestroyed() signal, instead of the destructor. The emission of
  // the signal will be followed by an invocation of initializeGL() where we
  // can recreate all resources.
  connect(context(), &QOpenGLContext::aboutToBeDestroyed, this, &OpenGLWidget::cleanup);

  initializeOpenGLFunctions();
  glClearColor(0, 0, 0, m_Transparent ? 0 : 1);
}


//-----------------------------------------------------------------------------
void OpenGLWidget::paintGL()
{

}


//-----------------------------------------------------------------------------
void OpenGLWidget::resizeGL(int w, int h)
{
}


} // end namespace
