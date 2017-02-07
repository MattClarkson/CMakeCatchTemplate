/*=============================================================================

  MYPROJECT: A software package for whatever.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#define CATCH_CONFIG_RUNNER  // This tells Catch we provide main.
#include "catch.hpp"
#include "mpCatchMain.h"

// Global! Only do this in a private test harness.
namespace mp
{
int argc;
char** argv;
}

int main (int argc, char * const argv[])
{
  mp::argc = argc;
  mp::argv = const_cast<char**>(argv);

  Catch::Session session; // There must be exactly once instance

  int tmpArgc = 1;
  char *tmpCommandName = new char[256];
  strcpy(tmpCommandName, argv[0]);

  int returnCode = session.applyCommandLine(tmpArgc, const_cast<char * const *>(&tmpCommandName));
  if(returnCode != 0) // Indicates a command line error
    return returnCode;

  int sessionReturnCode = session.run();

  delete [] tmpCommandName;
  return sessionReturnCode;
}

