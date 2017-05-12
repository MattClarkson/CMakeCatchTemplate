/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpModelBackend_h
#define mpModelBackend_h

#include "mpQtVTKModelWin32ExportHeader.h"

#include <QObject>

namespace mp
{

/**
* \class ModelBackend
* \brief Demo backend, to contain VTK pipelines.
*
* Intended to demonstrate that this class knows nothing about the View,
* and is controlled via Qt signals and slots.
*
* Also note that this class is not a QWidget, it derives from QObject.
*/
MYPROJECT_QTVTKMODELWINEXPORT
class ModelBackend : public QObject
{
  Q_OBJECT

public:

  ModelBackend(QObject* parent);
  virtual ~ModelBackend();

signals:

public slots:

private slots:

}; // end class

} // end namespace

#endif
