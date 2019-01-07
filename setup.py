# /*============================================================================
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
# ============================================================================*/

# Note: The whole premise of this setup.py is that this project is primarily
# a C++ project, for C++ developers. So, all CMake-ing, and Building is
# done in a pre-existing and pre-configured C++ build directory.
# The only CMake variables that this script sets are:
#   MYPROJECT_PYTHON_MODULE_NAME to give the output python module the correct name.
#   MYPROJECT_PYTHON_OUTPUT_DIRECTORY to produce the output python module in the correct place
# Furthermore, the Python build environment must not pick up a different version of CMake.
# The required CMake version is set in CMakeLists.txt as a C++ developer would expect.

import os
import platform
import re
import subprocess
import six
from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
from distutils.version import LooseVersion
import versioneer

# Get the long description, as top-level README.md
with open('README.md') as f:
    long_description = f.read()

# Get the top-level folder name of this project.
dir_path = os.path.dirname(os.path.realpath(__file__))
dir_name = os.path.split(dir_path)[1]


class CMakeExtension(Extension):
    def __init__(self, name, sourcedir=''):
        Extension.__init__(self, name, sources=[])
        self.source_dir = os.path.abspath(sourcedir)
        self.super_build_dir = os.path.join(self.source_dir, 'build')
        self.build_dir = os.path.join(self.super_build_dir, 'MYPROJECT-build')


class CMakeBuild(build_ext):
    def run(self):
        try:
            out = subprocess.check_output(['cmake', '--version'])
        except OSError:
            raise RuntimeError("CMake must be installed to build the following extensions: " +
                               ", ".join(e.name for e in self.extensions))

        cmake_version = LooseVersion(re.search(r'version\s*([\d.]+)', out.decode()).group(1))
        six.print_("CMake version in python build:" + str(cmake_version))

        for ext in self.extensions:
            self.build_extension(ext)

    def build_extension(self, ext):
        ext_dir = os.path.abspath(os.path.dirname(self.get_ext_fullpath(ext.name)))
        cmake_args = ['-DMYPROJECT_PYTHON_OUTPUT_DIRECTORY=' + ext_dir,
                      '-DMYPROJECT_PYTHON_MODULE_NAME=' + self.distribution.get_name()
                      ]
        build_args = []

        six.print_("build_extension:name=" + str(ext.name))
        six.print_("build_extension:ext_dir=" + str(ext_dir))
        six.print_("self.distribution.get_name()=" + str(self.distribution.get_name()))

        cfg = 'Debug' if self.debug else 'Release'
        cmake_args += ['-DCMAKE_BUILD_TYPE=' + cfg]

        if platform.system() == "Windows":
            cmake_args += ['--config', cfg]
            build_args += ['--config', cfg]
        if os.environ.get('COMPILER') is not None:
            cmake_args += ['-G', '"' + str(os.environ.get('COMPILER')) + '"']

        env = os.environ.copy()

        subprocess.check_call(['cmake', ext.source_dir] + cmake_args, cwd=ext.build_dir, env=env)
        subprocess.check_call(['cmake', '--build', '.'] + build_args, cwd=ext.build_dir)


setup(
    # Must match python module name in your c++ code, or else you end
    # up with two dynamically linked libraries inside one wheel.
    name=dir_name + 'python',

    # Must match the version number in CMakeLists.txt.
    # We could try to parse the CMakeLists.txt file, but lets keep it simple.
    version=versioneer.get_version(),
    author='Myself',
    author_email='me@mydomain.com',
    description='A software package for whatever.',
    long_description=long_description,
    long_description_content_type='text/markdown',
    ext_modules=[CMakeExtension(dir_name, dir_path)],
    cmdclass=dict(build_ext=CMakeBuild),
    zip_safe=False,
    license='BSD-3 license',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Intended Audience :: Healthcare Industry',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3',
        'Topic :: Scientific/Engineering :: Information Analysis',
        'Topic :: Scientific/Engineering :: Medical Science Apps.',
    ],

    keywords='medical imaging',

    install_requires=[
        'six>=1.10',
        'numpy>=1.11',
    ],
)
