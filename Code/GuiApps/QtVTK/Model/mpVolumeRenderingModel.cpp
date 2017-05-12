/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpVolumeRenderingModel.h"
#include <stdexcept>
#include <cassert>

namespace mp
{

//-----------------------------------------------------------------------------
VolumeRenderingModel::VolumeRenderingModel()
{
  m_Renderer = vtkSmartPointer<vtkRenderer>::New();
}


//-----------------------------------------------------------------------------
VolumeRenderingModel::~VolumeRenderingModel()
{
}


//-----------------------------------------------------------------------------
vtkRenderer* VolumeRenderingModel::GetRenderer() const
{
  return m_Renderer.GetPointer();
}


//-----------------------------------------------------------------------------
void VolumeRenderingModel::LoadFile(const QString& fileName)
{
}

} // end namespace
