/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef mpWin32ExportHeader_h
#define mpWin32ExportHeader_h

/**
* \file mpWin32ExportHeader.h
* \brief Header to sort Windows dllexport/dllimport.
*/

#if (defined(_WIN32) || defined(WIN32)) && !defined(MYPROJECT_STATIC)
  #ifdef MYPROJECT_WINDOWS_EXPORT
    #define MYPROJECT_WINEXPORT __declspec(dllexport)
  #else
    #define MYPROJECT_WINEXPORT __declspec(dllimport)
  #endif  /* MYPROJECT_WINEXPORT */
#else
/* linux/mac needs nothing */
  #define MYPROJECT_WINEXPORT
#endif

#endif
