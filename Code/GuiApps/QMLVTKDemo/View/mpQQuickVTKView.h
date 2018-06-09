/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpQQuickVTKView_h
#define mpQQuickVTKView_h

#include <QQuickView>
#include <vtkSmartPointer.h>
#include <vtkExternalOpenGLRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkInteractorStyleMultiTouchCamera.h>

class vtkRenderer;

namespace mp
{

/**
 * \class QQuickVTKView
 * \brief Renders a VTK scene into a QQuickView
 */
class QQuickVTKView : public QQuickView {

  Q_OBJECT

public:

  virtual ~QQuickVTKView();
  QQuickVTKView(QWindow * parent = 0);
  QQuickVTKView(QQmlEngine * engine, QWindow * parent);
  QQuickVTKView(const QUrl & source, QWindow * parent = 0);

  void AddRenderer(vtkRenderer* r);
  void RemoveRenderer(vtkRenderer *r);
  void SetEraseBeforeVTKRendering(bool b);
  void SetEnabled(bool isEnabled);

signals:

  /**
   * \brief Triggered before VTK renders.
   * Must be connected using Qt::DirectConnection.
   */
  void beforeVTKRendering();

  /**
   * \brief Triggered after VTK renders.
   * Must be connected using Qt::DirectConnection.
   */
  void afterVTKRendering();

private slots:

  void Render();

private:

  vtkSmartPointer<vtkExternalOpenGLRenderWindow>      m_VTKRenderWindow;
  vtkSmartPointer<vtkRenderWindowInteractor>          m_VTKRenderWindowInteractor;
  vtkSmartPointer<vtkInteractorStyleMultiTouchCamera> m_VTKInteractorStyleMultiTouchCamera;
  bool                                                m_EraseBeforeVTKRendering;
  void Init();

};

} // end namespace

#endif
