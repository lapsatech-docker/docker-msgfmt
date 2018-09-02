#!/bin/sh

echo "Cleanup..."
find /src -type f -name *.mo -exec rm -f {} \;

echo "Building..."
find /src -type f -name *.po -exec /po2mo.sh {} \;
