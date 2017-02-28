CMakeCatchTemplate
------------------

[![Build Status](https://travis-ci.org/MattClarkson/CMakeCatchTemplate.svg?branch=master)](https://travis-ci.org/MattClarkson/CMakeCatchTemplate)
[![Build Status](https://ci.appveyor.com/api/projects/status/5pm89ej732c1ekf0/branch/master)](https://ci.appveyor.com/project/MattClarkson/cmakecatchtemplate)


This is a simple project to demonstrate a reasonable
structure for CMake/CTest and Catch based projects.

You can either
 1. Clone this repo, and use directly
 2. Export the project (download without a .git folder), and then rename all instances of MYPROJECT,
 myproject, MyProject and the namespace mp with names of your choice, and then rename the top-level project folder.
 

The substitutions for the second option can be achieved manually or by editing and running `rename.sh`.
Credit and thanks go to [ddervs](https://github.com/ddervs) for `rename.sh`.

Note: Running `rename.sh` should be performed on a non-git folder and before running CMake for the first time.

Overview
--------

The features provided are:
 1. Meta-Build, a.k.a. SuperBuild to download and build Boost, Eigen and OpenCV.
 2. A single library for the main functionality - called myproject, so you should rename it.
 3. Unit tests, using Catch, and run with CTest - to demonstrate correctness and regression.
 4. A single command line application - to give the end user a functioning program.
 5. KWStyle to check some basic code style - for consistency
 6. CppCheck to check some code features - for performance, style and correctness
 7. Doxygen config - for documentation
 8. CI build with Travis


Tested On
-----------------------------

 * Windows - Windows 8, VS2012, CMake 3.3.1
 * Linux - Centos 7, g++ 4.8.5, CMake 3.5.1
 * Mac - OSX 10.10.5, clang 6.0, CMake 3.6.3

With all other versions - good luck.

Note: Installation and Packaging are not ready yet.


Build Instructions
-----------------------------

This project can be configured to build against Eigen, Boost and OpenCV.
These were chosen as an example of how to use CMake, and some common
C++ projects. These dependencies are optional, and this project
will compile without them.

Furthermore, these dependencies can be downloaded and built,
or the user can specify directories of previously compiled
libraries.

To download and build dependencies, use CMake to configure:

  * BUILD_SUPERBUILD:BOOL=ON

Then to select any of Eigen, Boost or OpenCV, use CMake to set:

  * BUILD_Eigen:BOOL=ON|OFF
  * BUILD_Boost:BOOL=ON|OFF
  * BUILD_OpenCV:BOOL=ON|OFF

So, if BUILD_SUPERBUILD=OFF, then CMake will just try finding
locally installed versions rather then downloading them.

To switch between static/dynamic linking, use CMake to set:

  * BUILD_SHARED_LIBS:BOOL=ON|OFF

To switch between Debug and Release mode, use CMake to set:

  * CMAKE_BUILD_TYPE:STRING=Debug|Release

Note: Only Debug and Release are supported. 

As mentioned in lectures, CMake will find 3rd party libraries using either
  1. a FindModule.cmake included within CMake's distribution, e.g. Boost
  2. a custom made FindModule.cmake, e.g. Eigen
  3. using CMAKE_PREFIX_PATH and 'config mode' e.g. OpenCV

(where Module is the name of your module, e.g. OpenCV, Boost).

However, your host system is very likely to have a version of Boost that
is different to the one assumed here. So if you want to turn Boost on,
you should probably try and use the one provided by this SuperBuild.


Windows Users
-------------

If you build the project with shared libraries (BUILD_SHARED_LIBS:BOOL=ON)
then when you run executables, you should look for the batch file
StartVS_Debug.bat or StartVS_Release.bat in the MYPROJECT-build folder.
This sets the path before launching Visual Studio, so that dynamically
loaded libraries are found at run time.


Preferred Branching Workflow
----------------------------

 1. Raise issue in this project's Github Issue Tracker.
 2. Fork repository.
 3. Create a feature branch called ```<issue-number>-<some-short-description>```
    replacing ```<issue-number>``` with the Github issue number
    and ```<some-short-description>``` with your description of the thing you are implementing.
 4. Code on that branch.
 5. Push to your remote when ready.
 6. Create pull request.
 7. We will review code, and merge to master when it looks ready.
