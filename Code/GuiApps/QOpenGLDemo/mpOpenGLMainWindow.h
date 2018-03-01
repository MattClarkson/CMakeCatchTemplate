/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpOpenGLMainWindow_h
#define mpOpenGLMainWindow_h

#include <QMainWindow>

namespace mp
{

class OpenGLWidget;

/**
 * \class OpenGLMainWindow
 * \brief Demo QMainWindow subclass just to hold our OpenGLWidget.
 */
class OpenGLMainWindow : public QMainWindow
{

public:

  OpenGLMainWindow();

private:

  OpenGLWidget *m_Widget;
};

} // end namespace

#endif
