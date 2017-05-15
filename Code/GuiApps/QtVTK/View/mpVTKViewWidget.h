/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpVTKViewWidget_h
#define mpVTKViewWidget_h

#include "mpQtVTKViewWin32ExportHeader.h"
#include <vtkSmartPointer.h>
#include <vtkRenderer.h>

#include <QVTKWidget2.h>

namespace mp
{

/**
* \class VTKViewWidget
* \brief Demo widget to provide a standard VTK window.
*
* You could just use QVTKWidget2 directly, as at the moment,
* this is just a placeholder in case we want more logic.
*/
MYPROJECT_QTVTKVIEWWINEXPORT
class VTKViewWidget : public QVTKWidget2
{
  Q_OBJECT

public:

  VTKViewWidget(QWidget* parent);
  virtual ~VTKViewWidget();

  void AddRenderer(vtkRenderer* r);

public slots:

  void Render();

}; // end class

} // end namespace

#endif
