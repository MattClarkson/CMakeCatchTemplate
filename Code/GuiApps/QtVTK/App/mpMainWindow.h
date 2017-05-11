/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpMainWindow_h
#define mpMainWindow_h

#include "ui_mpMainWindow.h"

#include <QMainWindow>

namespace mp
{

/**
* \class MainWindow
* \brief Demo widget provides main window!
*/
class MainWindow : public QMainWindow, public Ui_MainWindow
{
  Q_OBJECT

public:

  MainWindow();

}; // end class

} // end namespace

#endif
