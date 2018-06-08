/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpQOpenGLTriangleRenderer_h
#define mpQOpenGLTriangleRenderer_h

#include <QObject>
#include <QtGui/QOpenGLFunctions>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLVertexArrayObject>
#include <QtGui/QOpenGLBuffer>
#include <QtQuick/QQuickWindow>

#ifdef BUILD_VTK
#include <vtkSmartPointer.h>
#include <vtkCubeSource.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkExternalOpenGLRenderer.h>
#include <vtkExternalOpenGLRenderWindow.h>
#include <vtkCommand.h>
#endif

namespace mp
{


class vtkMakeCurrentCallback : public vtkCommand
{
public:
  QQuickWindow *window;
  static vtkMakeCurrentCallback *New() { return new vtkMakeCurrentCallback; }
  void Execute(vtkObject *caller,
               unsigned long eventId,
               void *callData)
  {
    window->openglContext()->makeCurrent(window->openglContext()->surface());
  }
};

class vtkIsCurrentCallback : public vtkCommand
{
public:
  QQuickWindow *window;
  static vtkIsCurrentCallback *New() { return new vtkIsCurrentCallback; }
  void Execute(vtkObject *caller,
               unsigned long eventId,
               void *callData)
  {
    bool *tmp = reinterpret_cast<bool*>(callData);
    *tmp = window->openglContext()->isValid();
  }
};

class vtkFrameCallback : public vtkCommand
{
public:
  QQuickWindow *window;
  static vtkFrameCallback *New() { return new vtkFrameCallback; }
  void Execute(vtkObject *caller,
               unsigned long eventId,
               void *callData)
  {
  }
};

/**
 * \class QOpenGLTriangleRenderer
 * \brief Demo View class to render a TriangleModel into a QQuickWindow using OpenGL.
 */
class QOpenGLTriangleRenderer : public QObject, protected QOpenGLFunctions
{
  Q_OBJECT

public:

  QOpenGLTriangleRenderer();
  ~QOpenGLTriangleRenderer();

  void setDegrees(qreal d) { m_Degrees = d; }
  void setViewportSize(const QSize &size);
  void setWindow(QQuickWindow *window);
  void setTriangleData(QVector<float>* data);

public slots:

  void paint();

private:

  qreal                     m_Degrees;
  QSize                     m_ViewportSize;
  QQuickWindow             *m_Window;
  QOpenGLShaderProgram     *m_Program;
  QOpenGLVertexArrayObject  m_VAO;
  QOpenGLBuffer             m_VBO;
  QVector<float>           *m_TriangleData;
  bool                      m_TriangleDataDirty;
  int                       m_ProjMatrixLoc;
  int                       m_ModelViewMatrixLoc;
  QMatrix4x4                m_ProjMatrix;
  QMatrix4x4                m_ModelViewMatrix;
  QMatrix4x4                m_CameraMatrix;

#ifdef BUILD_VTK
  vtkSmartPointer<vtkCubeSource>                 m_CubeSource;
  vtkSmartPointer<vtkPolyDataMapper>             m_CubeMapper;
  vtkSmartPointer<vtkActor>                      m_CubeActor;
  vtkSmartPointer<vtkRenderer>                   m_VTKRenderer;
  vtkSmartPointer<vtkExternalOpenGLRenderWindow> m_VTKRenderWindow;
  vtkSmartPointer<vtkMakeCurrentCallback>        m_VTKMakeCurrentCallback;
  vtkSmartPointer<vtkIsCurrentCallback>          m_VTKIsCurrentCallback;
  vtkSmartPointer<vtkFrameCallback>              m_VTKFrameCallback;
#endif

};

} // end namespace

#endif
