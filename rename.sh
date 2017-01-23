#!/usr/bin/env bash

# Danial Dervovic (2017)
# Script which changes generic name MyProject, namespace mp etc to a project name of your choice.
# USAGE: Just change the variables prefixed by NEW below to an appropriate name then run the script.

######################################################
##                 EDIT THIS PART                   ##
######################################################

NEW_PROJECT_NAME_CAMEL_CASE='NewProject';
NEW_PROJECT_NAME_LOWER_CASE='newproject';
NEW_PROJECT_NAME_CAPS='NEWPROJECT';
NEW_SHORT_DESCRIPTION='A project for doing stuff.';
NEW_NAMESPACE='newproj';


######################################################

# Strings to replace

OLD_DIR_NAME='CMakeCatchTemplate';
OLD_PROJECT_NAME_CAMEL_CASE='MyProject';
OLD_PROJECT_NAME_LOWER_CASE='myproject';
OLD_PROJECT_NAME_CAPS='MYPROJECT';
OLD_DOXYGEN_INTRO='MyProject is a software library to perform whatever.'
OLD_SHORT_DESCRIPTION='MyProject: A software package for whatever.';
OLD_NAMESPACE='mp';

#### Replacements ###

find_and_replace_string(){
    git grep -lz "$1" './*' ':!/*.sh' | xargs -0 perl -i'' -pE 's/'"$1"'/'"$2"'/g';
}

find_and_replace_filename(){
    find . -name *$1* | sed -e "p;s/$1/$2/" | xargs -n2 mv
}

find_and_replace_filename_and_string(){
    find_and_replace_filename $1 $2
    find_and_replace_string $1 $2
}

# Change comment at top of each file describing project
find_and_replace_string "${OLD_SHORT_DESCRIPTION}" "${NEW_PROJECT_NAME_CAMEL_CASE}"": ""${NEW_SHORT_DESCRIPTION}" ;

# Change Doxygen intro
find_and_replace_string "${OLD_DOXYGEN_INTRO}" "${NEW_PROJECT_NAME_CAMEL_CASE}"": ""${NEW_SHORT_DESCRIPTION}";

# Replace name MyProject, myproject, MYPROJECT
find_and_replace_string "$OLD_PROJECT_NAME_CAMEL_CASE" "$NEW_PROJECT_NAME_CAMEL_CASE"
find_and_replace_string "$OLD_PROJECT_NAME_LOWER_CASE" "$NEW_PROJECT_NAME_LOWER_CASE"
find_and_replace_string "$OLD_PROJECT_NAME_CAPS" "$NEW_PROJECT_NAME_CAPS"

# namespace
find_and_replace_string "namespace $OLD_NAMESPACE" "namespace $NEW_NAMESPACE"

# Filename replacements
find_and_replace_filename "$OLD_PROJECT_NAME_CAMEL_CASE" "$NEW_PROJECT_NAME_CAMEL_CASE"
find_and_replace_filename "$OLD_PROJECT_NAME_LOWER_CASE" "$NEW_PROJECT_NAME_LOWER_CASE"
find_and_replace_filename "$OLD_PROJECT_NAME_CAPS" "$NEW_PROJECT_NAME_CAPS"

# mp prefixes
declare -a file_names=("BasicTypes.cpp" "BasicTypes.h"
                "MyFunctions.cpp" "MyFunctions.h"
                "Win32ExportHeader.h"
                "BasicTest.cpp"
                "CatchMain.cpp" "CatchMain.h"
                "CommandLineArgsTest.cpp"
                "BasicTest" "CommandLineArgsTest"
                )

for i in "${file_names[@]}"
do
    find_and_replace_filename_and_string "${OLD_NAMESPACE}${i}" "${NEW_NAMESPACE}${i}"
done


#mv ../CMakeCatchTemplate ../"${NEW_PROJECT_NAME}"