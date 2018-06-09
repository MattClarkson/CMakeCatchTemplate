/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include <QGuiApplication>
#include "MyProjectConfigure.h"
#include <mpTriangleModel.h>
#ifdef BUILD_VTK // for demo purposes only. In practice I wouldnt mix VTK with other OpenGL.
#include <mpQQuickVTKView.h>
#include <mpCubeModel.h>
#else
#include <QQuickView>
#endif

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("UCL");
  app.setApplicationName("QMLDemo");
  app.setApplicationVersion(QString(MYPROJECT_VERSION_STRING));

  qmlRegisterType<mp::TriangleModel>("QMLDemo", 1, 0, "TriangleModel");

#ifdef BUILD_VTK // for demo purposes only. In practice I wouldnt mix VTK with other OpenGL.
  qmlRegisterType<mp::CubeModel>("QMLDemo", 1, 0, "CubeModel");
#endif

  QSurfaceFormat fmt;
  fmt.setDepthBufferSize(24);
  fmt.setVersion(3, 2);
  fmt.setProfile(QSurfaceFormat::CoreProfile);
  QSurfaceFormat::setDefaultFormat(fmt);

#ifdef BUILD_VTK // for demo purposes only. In practice I wouldnt mix VTK with other OpenGL.
  mp::QQuickVTKView view;
#else
  QQuickView view;
#endif
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.show();

  return app.exec();

}

