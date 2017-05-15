/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include <QApplication>
#include "mpMainWindow.h"
#include <mpVolumeRenderingModel.h>
#include <QScopedPointer>

int main(int argc, char** argv)
{
  QApplication app(argc, argv);
  app.setOrganizationName("UCL");
  app.setApplicationName("Example QtVTK app.");

  QScopedPointer<mp::VolumeRenderingModel> mb(new mp::VolumeRenderingModel());

  mp::MainWindow mainWin(mb.data());
  mainWin.show();
  mainWin.ConnectRenderer();
  mainWin.showMaximized();

  return app.exec();
}
