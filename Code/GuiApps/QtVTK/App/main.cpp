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
#include <mpModelBackend.h>
#include <QScopedPointer>

int main(int argc, char** argv)
{
  QApplication app(argc, argv);
  app.setOrganizationName("UCL");
  app.setApplicationName("Example QtVTK app.");

  QScopedPointer<mp::ModelBackend> mb(new mp::ModelBackend());

  mp::MainWindow mainWin(mb.data());
  mainWin.showMaximized();

  // Starts event loop.
  return app.exec();
}
