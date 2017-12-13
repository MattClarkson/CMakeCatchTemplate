CMakeCatchTemplate
------------------

[![Build Status](https://travis-ci.org/MattClarkson/CMakeCatchTemplate.svg?branch=master)](https://travis-ci.org/MattClarkson/CMakeCatchTemplate)
[![Build Status](https://ci.appveyor.com/api/projects/status/5pm89ej732c1ekf0/branch/master)](https://ci.appveyor.com/project/MattClarkson/cmakecatchtemplate)


Purpose
-------

This is a demo project to demonstrate a reasonable structure for CMake/CTest/Catch based projects.


Features
--------

The main features provided are:

 1. A Meta-Build, also known as a SuperBuild, to optionally download and build Boost, Eigen, OpenCV, glog, gflags, VTK and PCL.
 2. A single library into which you can provide your main algorithms.
 3. Unit tests, using Catch, and run with CTest, so you can ensure correctness and enable regression testing of your functionality.
 4. A single command line application, to give the end user a minimalist runnable program.
 5. KWStyle to check some basic code style, so you can check for consistent code style.
 6. CppCheck to check some code features, so you can check for some performance, style and correctness issues.
 7. Doxygen config, so you can generate documentation.
 8. If your code is open-source, you can register with a Continuous Integration service, so this project provides Travis and Appveyor examples.
 9. CPack setup to produce installers for GUI apps QtVTKApp and QMLDemo along with installers for command line apps.
10. An example of the CMake required to build python interfaces to your C++ code, using ```boost::python```.


Usage
-----

The main way to use this project is:

 1. Clone this project.
 2. Rename the top-level project folder to the folder name of your choice.
 3. Rename all instances of ```MYPROJECT``` (all uppercase), ```myproject``` (all lowercase), ```MyProject``` (camelcase) and the namespace ```mp``` with names of your choice.
 4. Optionally strip out or turn off the bits you dont need.
 5. Set your KWStyle and CppCheck settings in ```Utilities/KWStyle``` and ```Utilities/CppCheck```.
 6. Check it all still builds.
 7. Check the unit tests pass.
 8. Fix anything that doesn't pass.
 9. Commit it to your own git repository.
10. Set the remote URL correctly.

So, right from your first commit, you will have a lot of functionality inherited from this project, and the commit log.

The substitutions for the second part can be achieved manually or by editing and running `rename.sh` in a unix bash environment (not git bash).
Credit and thanks go to [ddervs](https://github.com/ddervs) for `rename.sh`. Running `rename.sh` should be performed on a non-git folder and before running CMake for the first time.


A Note on Packaging
-------------------

There are many different issues and combinations to test when packaging an application. For example:

 * System: Windows / Linux / Mac.
 * Linkage: Shared libraries / Static libraries.
 * Executable style: Command line applications / GUI applications / Command line applications bundled with GUI applications.
 * With or without python.
 * The developer runs ```make install``` to install it in a specific directory, linked against known libraries, in known locations.
 * The developer runs ```make package``` to make a relocatable and distributable bundle so that another user can install it anywhere.

It would take too long to document all of them and all of the issues involved. So, this project suggests
some simple starting points, and recommendations.

Assumptions:

 1. This project is only suitable for small research projects, and the aim is to get simple libraries and apps done quickly. If you want bigger examples, then example projects like [DREAM3D](https://github.com/BlueQuartzSoftware/DREAM3D) or [FreeSurfer](https://github.com/freesurfer/freesurfer) can be used as illustrations of much larger examples. However each one is written by an excellent software engineer who makes a lot of custom made packaging code. So, anything more complex than what we have here, and you will have to write a lot of CMake code yourself.
 2. This project does not currently support dynamically discovered plugins that have no link-time dependency. This would require more CMake coding. This isn't too difficult, if its a pure Qt plugin. Follow Qt documentation to compile it, but then you'd have to write packaging code yourself, as most Qt documentation assumes you are using ```qmake``` not ```cmake```.
 3. You have built your own Qt.

Lots of people would like to take a shortcut and use Qt that comes with a package manager on Linux,
or with Homebrew or Macports on MacOSX, or pre-compiled on Windows. I believe its quicker to
learn how to build it, than it is to cope with the wrong version, or a version that does not have the features you want.
It really doesn't take long to learn, and is quicker than debugging all the numerous problems, and its
quicker than sorting out deployment or packaging issues.

Note that Assumption 2 refers to dynamically loaded (i.e. discovered at run-time, with no link-time dependency) plugins which are not supported.
This project does support dynamically linked libraries (i.e. required at link time and run time, but shared between other libraries).


Supported Use-Cases
-------------------

This project is intended for the following 2 Use-Cases:

 1. You are developing a small library or command line app, and NOT a GUI. Your focus is the core algorithm.
 2. You are developing a GUI, or a GUI with supporting command line apps, so you are an application developer, or an integration developer.

For the first Use-Case it is recommended that you build everything statically. The packaging code will produce an
SDK to link against, so other people can be responsible for integrating your new algorithm into their app.
You can use non-GUI Qt, by turning on the flag MYPROJECT_USE_QT, but you should still use a version of Qt that has been compiled statically.
Be aware that CMake will search around your system for various Qt libraries. If your statically compiled version of
Qt has missing libraries, as you only compiled a subset of them, then CMake may well find other Qt libraries, possibly
with dynamic linkage, from somewhere unexpected on your system. This will cause a problem when running CPack.

For the second Use-Case, with GUI development, and particularly with Qt (which has various plugins) you should use shared linking.
This package will provide you with examples on how to build a GUI, but if you are building a GUI, this project will not build an installable SDK.
Any command line apps will be bundled with the GUI, and should refer to the same bundled libraries for consistency.
On Mac, proper ```.app``` bundles will be created.

If you switch between Use-Case 1 and 2, you will need a complete rebuild at the SuperBuild level.
This means, completely destroying the SuperBuild folder, and not just running ```make clean``` or the ```Clean```
task in Visual Studio.

For example, imagine you start with a command line app, and build without Qt, as you are just testing or using some VTK filters.
Then at some point you decide you want to add a Qt GUI, then you will also need to rebuild VTK to pick up the
Qt support classes like QVTKWidget. So you end up doing a full clean SuperBuild.

So, basically, pick your main options, up front, for the SuperBuild, and then don't change them or be prepared for a full clean build.

In Summary, the Use-Cases are:

 1. Library with command line app: Use static linking, set BUILD_SHARED_LIBS=OFF.
 2. GUI app or GUI with command line apps: Use dynamic linking, set BUILD_SHARED_LIBS=ON.


Tested On
---------

 * Windows - Windows 8, VS2013, CMake 3.6.3, Qt 5.4.2
 * Linux - Centos 7, g++ 4.8.5, CMake 3.5.1, Qt 5.6.2
 * Mac - OSX 10.10.5, clang 6.0, CMake 3.9.4, Qt 5.6.2

Minimum CMake version is 3.5. Minimum Qt is version 5. Qt4 is not supported and not planned to be supported.


Build Instructions
------------------

This project can be configured to build against Eigen, Boost, OpenCV, glog, gflags, VTK and PCL.
These were chosen as an example of how to use CMake, and some common
C++ projects. These dependencies are optional, and this project
will compile without them.

Furthermore, these dependencies can be downloaded and built,
or the user can specify directories of previously compiled
libraries.

To download and build dependencies, use CMake to set:

  * BUILD_SUPERBUILD:BOOL=ON

where ```ON``` is the default. Then to build any of Eigen, Boost or OpenCV etc., use CMake to set:

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

Note: your host system is very likely to have a version of Boost that
is different to the one provided here. So if you want to turn Boost on,
you should probably try and use the one provided by this SuperBuild.


Windows Users
-------------

If you build the project with shared libraries (BUILD_SHARED_LIBS:BOOL=ON)
then after the SuperBuild has successfully completed, you should look for the batch file
StartVS_Debug.bat or StartVS_Release.bat in the MYPROJECT-build folder.
This sets the path before launching Visual Studio, so that when you come to run your
application or unit tests within Visual Studio, the dynamically
loaded libraries are found at run time.


Remove Unwanted Code
--------------------

You may find that you do not need all of the code in this repository. We could have
made a different repository for each of the above Use-Cases, but then there would be a lot of code
duplication and overlap. So, for now, its all one repository. Take a look in the ```Code``` folder.
Remove the directories you do not need, and change ```Code/CMakeLists.txt``` accordingly.


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
