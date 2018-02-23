/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "mpVLTriangleRenderer.h"

namespace mp
{

static const char *vertexShaderSource =
    "#version 150 core\n"
    "in vec2 position;\n"
    "in vec3 color;\n"
    "out vec3 Color\n;"
    "uniform mat4 projMatrix;\n"
    "uniform mat4 mvMatrix;\n"
    "void main()\n"
    "{\n"
    "  Color = color;"
    "  gl_Position = projMatrix * mvMatrix * vec4(position, 0.0, 1.0);\n"
    "}\n";

static const char *fragmentShaderSource =
    "#version 150 core\n"
    "in vec3 Color;\n"
    "out vec4 outColor;\n"
    "void main()\n"
    "{\n"
    "  outColor = vec4(Color, 1.0);;\n"
    "}\n";

//-----------------------------------------------------------------------------
VLTriangleRenderer::VLTriangleRenderer()
: m_Degrees(0)
, m_Window(nullptr)
, m_TriangleData(nullptr)
, m_TriangleDataDirty(false)
{
}


//-----------------------------------------------------------------------------
VLTriangleRenderer::~VLTriangleRenderer()
{
}


//-----------------------------------------------------------------------------
void VLTriangleRenderer::setTriangleData(QVector<float>* data)
{
  m_TriangleData = data;
  m_TriangleDataDirty = true;
}


//-----------------------------------------------------------------------------
void VLTriangleRenderer::setViewportSize(const QSize &size)
{
  m_ViewportSize = size;
}


//-----------------------------------------------------------------------------
void VLTriangleRenderer::setWindow(QQuickWindow *window)
{
  m_Window = window;
}


//-----------------------------------------------------------------------------
void VLTriangleRenderer::paint()
{
}

} // end namespace
