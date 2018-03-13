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

// Must come before Qt, due to #ifndef __glext_h_ guard conflicts
#include <vlCore/VisualizationLibrary.hpp>
#include <vlGraphics/Rendering.hpp>
#include <vlGraphics/SceneManager.hpp>
#include <vlGraphics/OpenGLContext.hpp>

// Must come after VL
#include <QObject>
#include <QtQuick/QQuickWindow>

namespace mp
{

/**
 * \class VLTriangleRenderer
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

  bool                                     m_OpenGLInitialised;
  vl::OpenGLContextFormat                  m_OpenGLContextFormat;
  vl::ref<vl::OpenGLContext>               m_OpenGLContext;
  vl::ref<vl::Rendering>                   m_Rendering;
  vl::ref<vl::SceneManager>                m_SceneManager;
};

} // end namespace

#endif
