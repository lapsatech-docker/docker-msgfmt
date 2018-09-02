#!/bin/sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color

source=$1
target=`echo $source | sed -e 's/\.po$/\.mo/'`
msgfmt $source -o $target
echo -e "      ${GREEN}write $target${NC}"
