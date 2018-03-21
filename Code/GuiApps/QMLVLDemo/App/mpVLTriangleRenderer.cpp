/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#include "mpVLTriangleRenderer.h"

#include <vlGraphics/Rendering.hpp>
#include <vlGraphics/SceneManagerActorTree.hpp>
#include <vlCore/Colors.hpp>
#include "mpQMLVLOpenGLContext.h"

#include <QOpenGLContext>

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
, m_OpenGLInitialised(false)
{
  m_OpenGLContextFormat.setDoubleBuffer(true);
  m_OpenGLContextFormat.setRGBABits( 8,8,8,0 );
  m_OpenGLContextFormat.setDepthBufferBits(24);
  m_OpenGLContextFormat.setStencilBufferBits(8);
  m_OpenGLContextFormat.setMultisampleSamples(16);
  m_OpenGLContextFormat.setMultisample(false);
  m_OpenGLContextFormat.setFullscreen(false);
  m_OpenGLContextFormat.setOpenGLProfile( vl::GLP_Core );
  m_OpenGLContextFormat.setVersion( 3, 3 );

  vl::ref<vl::Rendering> rend = m_Rendering.get() && m_Rendering->as<vl::Rendering>() ? m_Rendering->as<vl::Rendering>() : new vl::Rendering;
  m_Rendering = rend.get();

  m_SceneManager = new vl::SceneManagerActorTree;
  m_Rendering->sceneManagers()->push_back(m_SceneManager.get());

  m_OpenGLContext = new mp::QMLVLOpenGLContext();
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
  QOpenGLContext *context = m_Window->openglContext();
  QSurfaceFormat fmt = context->format();
  // Set format values from m_OpenGLContextFormat
  context->setFormat(fmt);

  if (!m_OpenGLInitialised)
  {
    m_OpenGLContext->initGLContext(true);
    m_OpenGLContext->logOpenGLInfo();
    m_OpenGLInitialised = true;
    m_Rendering->renderer()->setFramebuffer( m_OpenGLContext->framebuffer());
  }

  m_OpenGLContext->framebuffer()->setWidth(m_ViewportSize.width());
  m_OpenGLContext->framebuffer()->setHeight(m_ViewportSize.height());
  m_Rendering->camera()->viewport()->setClearColor( vl::black );
}

} // end namespace
