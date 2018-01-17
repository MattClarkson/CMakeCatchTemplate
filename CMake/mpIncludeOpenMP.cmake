#/*============================================================================
#
#  MYPROJECT: A software package for whatever.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#============================================================================*/

if(MYPROJECT_USE_OPENMP)
  # Borrowed from PCL-1.8
  if((NOT APPLE) OR (NOT CMAKE_COMPILER_IS_GNUCXX) OR (GCC_VERSION VERSION_GREATER 4.2.1) OR (CMAKE_COMPILER_IS_CLANG))
    find_package(OpenMP)
    if(OpenMP_FOUND)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
      if(MSVC)
        if(MSVC_VERSION EQUAL 1500)
          set(OPENMP_DLL VCOMP90)
        elseif(MSVC_VERSION EQUAL 1600)
          set(OPENMP_DLL VCOMP100)
        elseif(MSVC_VERSION EQUAL 1700)
          set(OPENMP_DLL VCOMP110)
        elseif(MSVC_VERSION EQUAL 1800)
          set(OPENMP_DLL VCOMP120)
        elseif(MSVC_VERSION EQUAL 1900)
          set(OPENMP_DLL VCOMP140)
        elseif(MSVC_VERSION EQUAL 1910)
          set(OPENMP_DLL VCOMP140)
        endif()
        if(OPENMP_DLL)
          set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /DELAYLOAD:${OPENMP_DLL}D.dll")
          set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DELAYLOAD:${OPENMP_DLL}.dll")
        else(OPENMP_DLL)
          message(WARNING "Delay loading flag for OpenMP DLL is invalid.")
        endif(OPENMP_DLL)
      endif(MSVC)
    endif()
  else()
    message(FATAL_ERROR "You requested OpenMP, but your compiler does not support it. Please turn MYPROJECT_USE_OPENMP off.")
  endif()
  if(NOT OpenMP_FOUND)
    message(FATAL_ERROR "You requested OpenMP, but it was not found. Please turn MYPROJECT_USE_OPENMP off.")
  endif()
endif()
