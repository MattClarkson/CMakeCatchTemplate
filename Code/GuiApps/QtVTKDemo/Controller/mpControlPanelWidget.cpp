/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include "mpControlPanelWidget.h"
#include "mpTwinSliderWidget.h"
#include <cassert>

namespace mp
{

//-----------------------------------------------------------------------------
ControlPanelWidget::ControlPanelWidget(QWidget* parent)
: QWidget(parent)
{
  setupUi(this);

  bool ok = false;
  ok = connect(m_ExampleButton, SIGNAL(pressed()), SIGNAL(DoSomethingPressed()));
  assert(ok);
  ok = connect(m_TwinSliderWidget, SIGNAL(ValuesChanged(int, int)), SIGNAL(WindowValuesChanged(int,int)));
  assert(ok);
}


//-----------------------------------------------------------------------------
ControlPanelWidget::~ControlPanelWidget()
{
}


//-----------------------------------------------------------------------------
void ControlPanelWidget::SetIntensityRange(int low, int high)
{
  m_TwinSliderWidget->SetRange(low, high);
  m_TwinSliderWidget->SetValues(low, high);
}

} // end namespace
