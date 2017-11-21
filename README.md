CMakeCatchTemplate
------------------

[![Build Status](https://travis-ci.org/MattClarkson/CMakeCatchTemplate.svg?branch=master)](https://travis-ci.org/MattClarkson/CMakeCatchTemplate)
[![Build Status](https://ci.appveyor.com/api/projects/status/5pm89ej732c1ekf0/branch/master)](https://ci.appveyor.com/project/MattClarkson/cmakecatchtemplate)


This is a simple project to demonstrate a reasonable
structure for CMake/CTest/Catch based projects.

The main way to use it is:
 1. Export the project (download without a .git folder)
 2. Rename all instances of MYPROJECT, myproject, MyProject and the namespace mp with names of your choice
 3. Rename the top-level project folder to the folder name of your choice.
 4. Check it all still builds.
 5. Commit it to your own git repository.
 
The substitutions for the second part can be achieved manually or by editing and running `rename.sh`.
Credit and thanks go to [ddervs](https://github.com/ddervs) for `rename.sh`.

Note: Running `rename.sh` should be performed on a non-git folder and before running CMake for the first time.

Purely for testing purposes, you could just clone the repo, and build it, but then the project would
be called CMakeCatchTemplate which might sound a bit wierd for your own personal endeavours.


Overview
--------

The features provided are:
 1. Meta-Build, a.k.a. SuperBuild to optionally download and build Boost, Eigen, OpenCV, glog, gflags, VTK and PCL.
 2. A single library for the main functionality.
 3. Unit tests, using Catch, and run with CTest - to ensure correctness and enable regression testing.
 4. A single command line application - to give the end user a functioning program.
 5. KWStyle to check some basic code style - for consistent code style
 6. CppCheck to check some code features - for performance, style and correctness
 7. Doxygen config - for documentation
 8. CI build with Travis and appveyor (if project is open-source).
 9. CPack setup for GUI apps QtVTKApp and QMLDemo along with command line apps.


Tested On
-----------------------------

 * Windows - Windows 8, VS2013, CMake 3.6.3
 * Linux - Centos 7, g++ 4.8.5, CMake 3.5.1
 * Mac - OSX 10.10.5, clang 6.0, CMake 3.9.4

Minimum CMake version is 3.5.

With all other versions - good luck.


Build Instructions
-----------------------------

This project can be configured to build against Eigen, Boost, OpenCV, glog, gflags, VTK and PCL.
These were chosen as an example of how to use CMake, and some common
C++ projects. These dependencies are optional, and this project
will compile without them.

Furthermore, these dependencies can be downloaded and built,
or the user can specify directories of previously compiled
libraries.

To download and build dependencies, use CMake to configure:

  * BUILD_SUPERBUILD:BOOL=ON

Then to select any of Eigen, Boost or OpenCV etc., use CMake to set:

  * BUILD_Eigen:BOOL=ON|OFF
  * BUILD_Boost:BOOL=ON|OFF
  * BUILD_OpenCV:BOOL=ON|OFF

and so on. If BUILD_SUPERBUILD=OFF, and these variables are on, then CMake will just try finding
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


A Note On Packaging
-------------------

There are many different issues and combinations to test when packaging. For example:

 * System: Windows / Linux / Mac
 * Linkage: Shared libraries / Static libraries
 * Executable style: Command line applications / GUI applications / Command line applications bundled with GUI applications.
 * The developer runs ```make install``` to install it in a specific directory, linked against known libraries.
 * The developer runs ```make package``` to make a relocatable and distributable bundle so that another user can install it anywhere.

It would simply take too long to document all of them and all of the issues involved. So, this project suggests
some simple starting points, and recommendations.

Lets start with some assumptions:

 1. This project is only a demonstration for small research projects, and the aim is to get simple libraries and apps done quickly. If you want bigger examples, then example projects like [DREAM3D](https://github.com/BlueQuartzSoftware/DREAM3D) or [FreeSurfer](https://github.com/freesurfer/freesurfer) can be used as illustrations of much larger examples. However each one is written by an excellent software engineer who makes a lot of custom made packaging code. So, anything more complex than this, and you will have to write all your own CMake code.
 2. This project does not support dynamically loaded plugins. This would require more CMake coding. This isn't too bad, if its a pure Qt plugin. Follow Qt documentation to compile it, but then you'd have to write packaging code yourself, as most Qt documentation assumes you are using qmake not cmake.
 3. You have built your own Qt.

Lots of people would like to take a shortcut and use Qt that comes with a package manager on Linux,
or with Homebrew or Macports on MacOSX, or pre-compiled on Windows. I believe its quicker to
learn how to build it, than it is to cope with the wrong version, or a version that does not have the features you want.
It really doesn't take long to learn, and is quicker than debugging all the numerous problems, and its
quicker than sorting out deployment issues.

So, to further simplify matters, lets consider the following Use-Cases.

 1. You are developing a small library or command line app, and NOT a GUI. Your focus is the core algorithm. In that case, build everything statically. The packaging code will produce an SDK to link against, so other people can be responsible for integrating your new algorithm into their app. You can use non-GUI Qt, by turning on the flag MYPROJECT_USE_QT, but you should still compile Qt statically. Static linking makes ```make install``` and ```make package``` for command line apps and libraries so much easier.
 2. You are developing a GUI, or you are an application developer, or integration developer. In that case, you can use shared linking. This package will provide you with examples on how to build a GUI, but will not build a separate SDK. Any command line apps will be bundled with the GUI.

If you switch between 1 and 2, you will need a complete rebuild at the SuperBuild level.
For example, if you start with a command line app, and build without Qt, but you are using VTK filters.
Then at some point you decide you want to add a Qt GUI, then you will also need to rebuild VTK to pick up the
Qt support classes like QVTKWidget.

So, basically, pick your main options, up front, for the SuperBuild, and then don't change them or be prepared for a full clean build.


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
