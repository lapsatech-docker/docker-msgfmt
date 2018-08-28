#!/bin/sh

echo "`date` Cleanup..."
find /src -type f -name *.mo -exec rm -f {} \;

echo "`date` Building..."
find /src -type f -name *.po -exec /po2mo.sh {} \;
