/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpQMLVLOpenGLContext_h
#define mpQMLVLOpenGLContext_h

#include <vlGraphics/OpenGLContext.hpp>

namespace mp
{

class QMLVLOpenGLContext : public vl::OpenGLContext {

public:

  QMLVLOpenGLContext();
  void swapBuffers() {}
  void makeCurrent() {}
  void update() {}
};

} // end namespace

#endif

