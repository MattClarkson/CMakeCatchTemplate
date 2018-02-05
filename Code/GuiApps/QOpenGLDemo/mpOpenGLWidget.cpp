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
  this->doneCurrent();
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

  float vertices[] =
  {
    0.0f, 0.5f, // Vertex 1 (X, Y)
    0.5f, -0.5f, // Vertex 2 (X, Y)
    -0.5f, -0.5f // Vertex 3 (X, Y)
  };
  GLuint vbo;
  glGenBuffers(1, &vbo); // Generate 1 buffer
  glBindBuffer(GL_ARRAY_BUFFER, vbo);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}


//-----------------------------------------------------------------------------
void OpenGLWidget::paintGL()
{
  glClearColor(0, 0, 0, m_Transparent ? 0 : 1);
}


//-----------------------------------------------------------------------------
void OpenGLWidget::resizeGL(int w, int h)
{
}


} // end namespace
