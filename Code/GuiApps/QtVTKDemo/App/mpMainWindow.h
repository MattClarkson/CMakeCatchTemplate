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
#include <mpVolumeRenderingModel.h>

#include <QMainWindow>

namespace mp
{

class VTKViewWidget;

/**
* \class MainWindow
* \brief Demo Widget provides main window, and connects it to Model.
*/
class MainWindow : public QMainWindow, public Ui_MainWindow
{
  Q_OBJECT

public:

  MainWindow(mp::VolumeRenderingModel* model);
  virtual ~MainWindow();
  void ConnectRenderer();

private slots:

  void OnFileOpen();

private:

  mp::VolumeRenderingModel* m_Model;
  mp::VTKViewWidget*        m_Viewer;

}; // end class

} // end namespace

#endif
