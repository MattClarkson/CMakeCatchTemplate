#!/usr/bin/env bash

# Danial Dervovic (2017)
# Script which changes generic name MyProject, namespace mp etc to a project name of your choice.
# USAGE: Just change the variables prefixed by NEW below to an appropriate name then run the script.

######################################################
##                 EDIT THIS PART                   ##
######################################################

NEW_PROJECT_NAME='NewProject';
NEW_SHORT_DESCRIPTION='A project for doing stuff.';
NEW_NAMESPACE='newproj';


######################################################

# Strings to replace

OLD_DIR_NAME='CMakeCatchTemplate';
OLD_PROJECT_NAME='MyProject';
OLD_SHORT_DESCRIPTION='MyProject: A software package for whatever.';
OLD_NAMESPACE='mp';

#### Replacements ###

find_and_replace_string(){
    git grep -lz "$1" './*' ':!/*.sh'  | xargs -0 perl -i'' -pE 's/'"$1"'/'"$2"'/g';
}

# Change comment at top of each file describing project
find_and_replace_string "${OLD_SHORT_DESCRIPTION}" "${NEW_PROJECT_NAME}"": ""${NEW_SHORT_DESCRIPTION}" ;

# Change Doxygen intro
find_and_replace_string "MyProject is a software library to perform whatever." "${NEW_PROJECT_NAME}"": ""${NEW_SHORT_DESCRIPTION}";

# Replace name MyProject
#find_and_replace_string "MyProject" "$NEW_PROJECT_NAME"
#mv ../CMakeCatchTemplate ../"${NEW_PROJECT_NAME}"