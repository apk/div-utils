#!/bin/bash

if test -d "$HOME"/buildery/gobuild; then
    PATH="$HOME/buildery/gobuild/g/bin:$PATH"
fi

case "$1" in
    -win)
	export GOOS=windows
	export GOARCH=386
	shift
	;;
    -arm)
	export GOOS=linux
	export GOARCH=arm
	shift
	;;
    -arm6)
	export GOOS=linux
	export GOARCH=arm
	export GOARM=6
	shift
	;;
    -net)
	export GOOS=netbsd
	export GOARCH=386
	shift
	;;
    -netarm)
	export GOOS=netbsd
	export GOARCH=arm
	export GOARM=7
	shift
	;;
esac
d="`pwd`"
GOBIN="$d"/bin
export GOBIN
while true; do
    if test -r "$d/.gopath"; then
	GOPATH="$d"
	export GOPATH
	GOBIN="$d"/bin
	export GOBIN
	source "$d/.gopath"
	break
    fi
    if test "$d" = /; then
	echo "No .gopath found"
	break
    fi
    d="`dirname "$d"`"
done
if test "X$1" = X--; then
    shift
    exec "$@"
fi
exec go "$@"
