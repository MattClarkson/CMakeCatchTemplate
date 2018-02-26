/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include <vlCore/VisualizationLibrary.hpp>
#include <QGuiApplication>
#include <QtQuick/QQuickView>
#include "MyProjectConfigure.h"
#include "mpTriangleModel.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("UCL");
  app.setApplicationName("QMLVLDemo");
  app.setApplicationVersion(QString(MYPROJECT_VERSION_STRING));

  qmlRegisterType<mp::TriangleModel>("VLUnderQML", 1, 0, "TriangleModel");

  /* init Visualization Library */
  vl::VisualizationLibrary::init();

  QQuickView view;
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.show();

  /* shutdown Visualization Library */
  vl::VisualizationLibrary::shutdown();

  return app.exec();
}

