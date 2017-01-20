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
    git grep -lz "$1" './*' ':!/*.sh'  | xargs -0 perl -i'' -pE 's/'"$1"'/'"$2"'/g';
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
## Need to do summat clever here
#find_and_replace_string "$OLD_NAMESPACE" "$NEW_NAMESPACE"

# Filename replacements
find . -name *${OLD_PROJECT_NAME_CAMEL_CASE}* | sed -e "p;s/${OLD_PROJECT_NAME_CAMEL_CASE}/${NEW_PROJECT_NAME_CAMEL_CASE}/" | xargs -n2 mv
find . -name *${OLD_PROJECT_NAME_LOWER_CASE}* | sed -e "p;s/${OLD_PROJECT_NAME_LOWER_CASE}/${NEW_PROJECT_NAME_LOWER_CASE}/" | xargs -n2 mv
find . -name *${OLD_PROJECT_NAME_CAPS}* | sed -e "p;s/${OLD_PROJECT_NAME_CAPS}/${NEW_PROJECT_NAME_CAPS}/" | xargs -n2 mv

#mv ../CMakeCatchTemplate ../"${NEW_PROJECT_NAME}"