/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpTriangleModel_h
#define mpTriangleModel_h

#include <QtQuick/QQuickItem>
#include <QVector>
#include "mpQOpenGLTriangleRenderer.h"

namespace mp
{

/**
 * \class TriangleModel
 * \brief Demo Model class containing data for a single, rotateable, triangle.
 *
 * The degrees member variable is just to call something that has a visible side-effect.
 * This class does not contain much data. If you were doing a larger scale
 * example, you would pay carefull attention to optimising how often data
 * is pushed to the Renderer, and consequently, how often you need OpenGL
 * to update its buffers and such. You could do things like monitor 'dirty'
 * flags, and only upload to the renderer if absolutely necessary.
 */
class TriangleModel : public QQuickItem
{
  Q_OBJECT
  Q_PROPERTY(qreal degrees READ degrees WRITE setDegrees NOTIFY degreesChanged)

public:

  TriangleModel();

  /**
   * \name Data Setter Methods
   * These methods are called to update the data model.
   * If these are called from a thread other than the QML scenegraph
   * rendering thread, then you should ensure all locking/Mutexing is correct.
   */
  ///@{

  qreal degrees() const { return m_Degrees; }
  void setDegrees(qreal d);

  ///@}

signals:

  void degreesChanged();

public slots:

  /**
   * \name Render Thread Methods
   * These methods are normally called within the rendering thread. If your application
   * wants to call these methods, they should connect using a Qt::QueuedConnection,
   * and trigger an appropriate event, which is then processed by the rendering thread.
   */
  ///@{

  /// \brief Called when the current window emits QQuickWindow::beforeSynchronizing.
  void sync();

  /// \brief Called when the current window emits QQuickWindow::sceneGraphInvalidated.
  void cleanup();

  ///@}

private slots:

  void handleWindowChanged(QQuickWindow *win);

private:

  qreal                    m_Degrees;
  QOpenGLTriangleRenderer *m_Renderer;
  QVector<float>           m_TriangleData;

};

} // end namespace

#endif
