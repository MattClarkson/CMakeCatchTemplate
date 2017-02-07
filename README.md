CMakeCatchTemplate
------------------

This is a simple project to demonstrate a reasonable
structure for a cmake/ctest and Catch based projects.

You can either
 1. Clone this repo, and use directly
 2. Export the project (without a .git folder), and then rename all instances of MYPROJECT,
 myproject, MYPROJECT with names of your choice, and then create your own project.

Overview
--------

The features provided are:
 1. Some feature
 2. Another feature
 

Tested On
-----------------------------

 * Windows - Windows 8, VS2012, CMake 3.3.1
 * Linux - Centos 7, g++ 4.8.5, CMake 3.5.1
 * Mac - OSX 10.10.5, clang 6.0, CMake 3.6.3

With all other versions - good luck.


Build Instructions
-----------------------------

This project can be configured to build against Eigen, Boost and OpenCV.
These were chosen as an example on how to use CMake, and some common
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
