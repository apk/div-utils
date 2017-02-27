#!/bin/sh
if test "X$1" = X-alt; then
	PATH=$HOME/buildery/gobuild/g/bin:$PATH
	shift
else
	PATH=$HOME/gobuild/g/bin:$PATH
fi
if test "X$1" = X-win; then
	export GOOS=windows
	export GOARCH=386
	shift
elif test "X$1" = X-arm; then
	export GOOS=linux
	export GOARCH=arm
	shift
elif test "X$1" = X-netarm; then
	export GOOS=netbsd
	export GOARCH=arm
	export GOARM=7
	shift
fi
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
    exec "$@"
fi
exec go "$@"
