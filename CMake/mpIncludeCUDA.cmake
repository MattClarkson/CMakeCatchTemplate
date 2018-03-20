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

if(MYPROJECT_USE_CUDA)
  if( "${MYPROJECT_CUDA_ARCH_BIN}" STREQUAL "")
    message(FATAL_ERROR "If you turn MYPROJECT_USE_CUDA, you must specify a target architecture in MYPROJECT_CUDA_ARCH_BIN.")
  endif()
  find_package(CUDA)
  if(CUDA_FOUND)
    include_directories(${CUDA_TOOLKIT_INCLUDE})
    add_definitions(-DMYPROJECT_USE_CUDA)
    list(APPEND ALL_THIRD_PARTY_LIBRARIES ${CUDA_CUDA_LIBRARY} ${CUDA_CUDART_LIBRARY})
    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};-DMYPROJECT_USE_CUDA")
    if(APPLE)
      set(CMAKE_SHARED_LINKER_FLAGS "-F/Library/Frameworks ${CMAKE_SHARED_LINKER_FLAGS}")
    endif()
  else()
    message(FATAL_ERROR "You requested CUDA, but it was not found. Please set CUDA_TOOLKIT_ROOT_DIR or turn MYPROJECT_USE_CUDA off.")
  endif()
endif()
