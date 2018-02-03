/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpOpenGLWidget_h
#define mpOpenGLWidget_h

#include <QOpenGLWidget>
#include <QOpenGLFunctions>
#include <QOpenGLVertexArrayObject>
#include <QOpenGLBuffer>

QT_FORWARD_DECLARE_CLASS(QOpenGLShaderProgram)

namespace mp
{

/**
 * \class QOpenGLWidget
 * \brief Intended as an example or base class to demo how to setup
 * an OpenGL window, derived from Qt's QOpenGLWidget.
 */
class OpenGLWidget : public QOpenGLWidget, protected QOpenGLFunctions
{
  Q_OBJECT

public:

  OpenGLWidget(QWidget *parent = 0);
  ~OpenGLWidget();

  static bool IsTransparent() { return m_Transparent; }
  static void SetTransparent(bool t) { m_Transparent = t; }

  QSize minimumSizeHint() const override;
  QSize sizeHint() const override;

public slots:

  void cleanup();

protected:

  void initializeGL() override;
  void paintGL() override;
  void resizeGL(int width, int height) override;

private:

  static bool m_Transparent;
  bool m_Core;
  QOpenGLVertexArrayObject m_VAO;
  QOpenGLBuffer m_VBO;
  QOpenGLShaderProgram *m_Program;
};

} // end namespace

#endif
