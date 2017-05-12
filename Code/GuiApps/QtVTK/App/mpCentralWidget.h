/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpCentralWidget_h
#define mpCentralWidget_h

#include "ui_mpCentralWidget.h"
#include <mpVTKViewWidget.h>
#include <QWidget>

class vtkActor;

namespace mp
{

/**
* \class CentralWidget
* \brief Demo widget to group a VTKViewWidget with ControlPanelWidget.
*/
class CentralWidget : public QWidget, public Ui_CentralWidget
{
  Q_OBJECT

public:

  CentralWidget(QWidget* parent);
  virtual ~CentralWidget();

  VTKViewWidget* GetVTKViewWidget() const;

  void AddActor(vtkActor* a);

}; // end class

} // end namespace

#endif
