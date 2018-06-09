/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpCubeModel_h
#define mpCubeModel_h

#include "mpBaseModel.h"

#include <vtkSmartPointer.h>
#include <vtkCubeSource.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkRenderer.h>

namespace mp {

/**
 * \classCubeModel
 * \brief Represents a Cube using VTK.
 */
class CubeModel : public BaseModel
{
  Q_OBJECT
  Q_PROPERTY(qreal degrees READ degrees WRITE setDegrees)

  /**
   * \name Data Setter Methods
   * These methods are called to update the data model.
   */
  ///@{

  qreal degrees() const { return m_Degrees; }
  void setDegrees(qreal d);

  ///@}

protected:

  virtual void InternalCleanup();
  virtual void InternalSync();

public:

  CubeModel();

private:

  bool                               m_Connected;
  qreal                              m_Degrees;
  vtkSmartPointer<vtkCubeSource>     m_CubeSource;
  vtkSmartPointer<vtkPolyDataMapper> m_CubeMapper;
  vtkSmartPointer<vtkActor>          m_CubeActor;
  vtkSmartPointer<vtkRenderer>       m_Renderer;
};

} // end namespace

#endif
