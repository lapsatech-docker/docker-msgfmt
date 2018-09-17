#!/bin/sh

function usage_and_die {
	echo "Usage: docker run lapsatech/msgfmt xgettext|(msginit LANG COUNTRY)|(msgmerge LANG COUNTRY)"
	exit 1
}


WEB=/web # исходный код сайта PHP
SRC=/src # исходники POT и PO
I18N=/i18n # комплирированные MO

POT="$SRC/messages.pot"

case "$1" in
	xgettext)
		echo "Extracting to $POT..."
		echo xgettext --from-code=UTF-8 --keyword=_ --language=php --add-comments --sort-output -o $POT $(find $WEB -type f -name \*.php)
		xgettext --from-code=UTF-8 --keyword=_ --language=php --add-comments --sort-output -o $POT $(find $WEB -type f -name \*.php)
		exit
	;;
	msginit)
		LANG="$2"
		COUNTRY="$3"
		test -z $LANG && usage_and_die
		test -z $COUNTRY && usage_and_die
		LC="${LANG}_${COUNTRY}"
		PO="$SRC/$LC/LC_MESSAGES/$LANG.po"
		test -f $POT || { echo "No POT $POT. Use xgettext to generate"; usage_and_die; }
		test -f $PO  && { echo "Already exists $PO. Use msgmerge instead"; usage_and_die; }
		echo "Creating $PO..."
		mkdir -p $(dirname $PO)
		echo msginit --input=$POT --locale $LC --output=$PO
		msginit --input=$POT --locale $LC --output=$PO
		exit
	;;
	msgmerge)
		LANG="$2"
		COUNTRY="$3"
		test -z $LANG && usage_and_die
		test -z $COUNTRY && usage_and_die
		LC="${LANG}_${COUNTRY}"
		PO="$SRC/$LC/LC_MESSAGES/$LANG.po"
		test -f $POT || { echo "No POT $POT. Use xgettext to generate"; usage_and_die; }
		test -f $PO  || { echo "No PO $PO. Use msginit instead"; usage_and_die; }
		echo "Updating $PO..."
		echo msgmerge --update --sort-output --backup=none $PO $POT
		msgmerge --update --sort-output --backup=none $PO $POT
		exit
	;;
	msgfmt)
		echo "Cleanup..."
		find /src -type f -name *.mo -exec rm -f {} \;
		
		echo "Building..."
		cd /src
		find . -name *.po -type f -exec sh -c 'FN=$0; SRC=/src/$FN; TARGET=/i18n/$(echo $FN | sed -e 's/\.po$/\.mo/'); mkdir -p $(dirname $TARGET); msgfmt "$SRC" -o "$TARGET"; ' {} \;
		exit
	;;
	*)
		usage_and_die
	;;
esac
