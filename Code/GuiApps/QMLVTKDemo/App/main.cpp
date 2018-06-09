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
#include <mpCubeModel.h>
#include <mpQQuickVTKView.h>

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("UCL");
  app.setApplicationName("QMLVTKDemo");
  app.setApplicationVersion(QString(MYPROJECT_VERSION_STRING));

  qmlRegisterType<mp::TriangleModel>("QMLVTKDemo", 1, 0, "TriangleModel");
  qmlRegisterType<mp::CubeModel>("QMLVTKDemo", 1, 0, "CubeModel");

  QSurfaceFormat fmt;
  fmt.setDepthBufferSize(24);
  fmt.setVersion(3, 2);
  fmt.setProfile(QSurfaceFormat::CoreProfile);
  QSurfaceFormat::setDefaultFormat(fmt);

  mp::QQuickVTKView view;
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.show();

  return app.exec();

}

