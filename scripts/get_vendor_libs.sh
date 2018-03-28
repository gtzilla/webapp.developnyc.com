#!/bin/bash
set -eu

cd $(dirname $0)
DESTDIR="../js-vendor"
mkdir -p $DESTDIR

JQUERY_URL="https://code.jquery.com/jquery-3.3.1.min.js"
JQUERY_VER="3.3.1"
JQUERY_SHA1="0dc32db4aa9c5f03f3b38c47d883dbd4fed13aae"

UNDERSCORE_URL="http://underscorejs.org/underscore-min.js"
UNDERSCORE_VER="1.8.3"
UNDERSCORE_SHA1="2a515632e0fd8ffdeb8d94cb25e44cf287feb32f"

# https://github.com/netlify/gotrue-js
GOTRUE_URL="https://raw.githubusercontent.com/netlify/gotrue-js/master/browser/gotrue.js"
GOTRUE_VER="1.0"
GOTRUE_SHA1="349b3ce5a8dcd364a7e1fe1debea0ecc37597a84"

if   which shasum  >/dev/null; then SHACMD="shasum -a1"
elif which sha1sum >/dev/null; then SHACMD="sha1sum"
else
	echo "ERROR: No supported sha1 tool found" 1>&2 ; exit 1
fi
check_hash() {
	$SHACMD "$1" | cut -d' ' -f1
}

fetch_file() {
	local FILENAME=$1
	local HASH=$2
	local URL=$3
	local FILEPATH=$DESTDIR/$FILENAME

	if [ -e $FILEPATH ] && [ $HASH = "$(check_hash $FILEPATH)" ]; then
		return
	fi

	echo "> Downloading $FILENAME ..."
	curl --compressed -s -k -L "$URL" > $FILEPATH
	if [ $HASH != "$(check_hash $FILEPATH)" ]; then
		echo "ERROR: $FILENAME hash mismatch. Check SHA1" 1>&2
		exit 1
	fi
}

fetch_file "jquery-${JQUERY_VER}.min.js" $JQUERY_SHA1 $JQUERY_URL
fetch_file "underscore-${UNDERSCORE_VER}.min.js" $UNDERSCORE_SHA1 $UNDERSCORE_URL
fetch_file "gotrue-${GOTRUE_VER}.js" $GOTRUE_SHA1 $GOTRUE_URL
