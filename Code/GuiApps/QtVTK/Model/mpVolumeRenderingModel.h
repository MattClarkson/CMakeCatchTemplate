/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpVolumeRenderingModel_h
#define mpVolumeRenderingModel_h

#include "mpQtVTKModelWin32ExportHeader.h"

#include <QObject>

class vtkActor;

namespace mp
{

/**
* \class VolumeRenderingModel
* \brief Demo backend, to contain VTK pipelines.
*
* Intended to demonstrate that this class knows nothing about the View.
* To further illustrate this point, this class is not a QWidget,
* it derives from QObject. This class is controlled via Qt signals and slots.
*
* It would be possible to make some of the rendering pipeline part of the View.
* However, the VTK rendering pipeline contains parameters, which must be set,
* and these parameters form part of the data-model. So, for simplicity's sake
* I have kept it all in the model. The View layer therefore just renders
* the actors, so should remain quite thin.
*/
MYPROJECT_QTVTKMODELWINEXPORT
class VolumeRenderingModel : public QObject
{
  Q_OBJECT

public:

  VolumeRenderingModel();
  virtual ~VolumeRenderingModel();

  void LoadFile(const QString& fileName);

signals:

  void NewActor(vtkActor*);

public slots:

private slots:

private:

}; // end class

} // end namespace

#endif
