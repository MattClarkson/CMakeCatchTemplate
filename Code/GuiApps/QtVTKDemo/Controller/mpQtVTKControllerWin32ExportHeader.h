/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpQtVTKControllerWin32ExportHeader_h
#define mpQtVTKControllerWin32ExportHeader_h

/**
* \file mpQtVTKControllerWin32ExportHeader.h
* \brief Header to sort Windows dllexport/dllimport.
*/

#if (defined(_WIN32) || defined(WIN32)) && !defined(MYPROJECT_STATIC)
  #ifdef MYPROJECT_QTVTKCONTROLLER_WINDOWS_EXPORT
    #define MYPROJECT_QTVTKCONTROLLERWINEXPORT __declspec(dllexport)
  #else
    #define MYPROJECT_QTVTKCONTROLLERWINEXPORT __declspec(dllimport)
  #endif
#else
  #define MYPROJECT_QTVTKCONTROLLERWINEXPORT
#endif

#endif
