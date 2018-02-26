/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpVLTriangleRenderer_h
#define mpVLTriangleRenderer_h

#include <QObject>
#include <QtQuick/QQuickWindow>
#include <vlCore/VisualizationLibrary.hpp>
#include <vlGraphics/OpenGL.hpp>
#include <vlGraphics/OpenGLContext.hpp>
#include <vlGraphics/Rendering.hpp>
#include <vlGraphics/GLSL.hpp>

namespace mp
{

/**
 * \class TriangleRenderer
 * \brief Demo View class to render a TriangleModel into a QQuickWindow using VL.
 */
class VLTriangleRenderer : public QObject
{
  Q_OBJECT

public:

  VLTriangleRenderer();
  ~VLTriangleRenderer();

  void setDegrees(qreal d) { m_Degrees = d; }
  void setViewportSize(const QSize &size);
  void setWindow(QQuickWindow *window);
  void setTriangleData(QVector<float>* data);

public slots:

  void paint();

private:

  qreal                                    m_Degrees;
  QSize                                    m_ViewportSize;
  QQuickWindow                            *m_Window;
  QVector<float>                          *m_TriangleData;
  bool                                     m_TriangleDataDirty;
  std::vector< vl::ref<vl::GLSLProgram> >  mGLSL;
};

} // end namespace

#endif
