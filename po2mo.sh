#!/bin/sh

source=$1
target=`echo $source | sed -e 's/\.po$/\.mo/'`
msgfmt $source -o $target
echo -e "write $target"
