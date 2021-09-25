#!/bin/bash

NEW_VERSION="$1"

MAJOR_VER=`echo $NEW_VERSION | cut -d . -f1`
MINOR_VER=`echo $NEW_VERSION | cut -d . -f2`
MCIRO_VER=`echo $NEW_VERSION | cut -d . -f3`

KEY_SECTION=`./automation.inprogress/create_key_section.sh`

BUILD_SECTION=`cat ./automation.inprogress/build.template`

FLAVORS=(webprofile plus plume microprofile)


for file in `find ./TomEE-$MAJOR_VER.$MINOR_VER -name Dockerfile`
do
  JAVA_VER=`echo $file | cut -d / -f3 | grep -o -E "[0-9]+"`

  for flavor in ${FLAVORS[*]}
  do
    echo "FROM openjdk:11-jre" > $file
    echo "" >> $file
    echo "ENV PATH /usr/local/tomee/bin:\$PATH" >> $file
    echo "RUN mkdir -p /usr/local/tomee">> $file
    echo "">> $file
    echo "WORKDIR /usr/local/tomee" >> $file
    echo "" >> $file
    echo "$KEY_SECTION" >> $file
    echo "" >> $file
    echo "ENV TOMEE_VER $NEW_VERSION" >> $file
    echo "ENV TOMEE_BUILD $flavor" >> $file
    echo "" >> $file
    echo "$BUILD_SECTION" >> $file
  done
done
