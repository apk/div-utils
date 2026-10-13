#!/bin/sh

# Append a timestamped note, together with the current
# directory, to $HOME/todo.txt; or show stored notes.
#
# Options:
#   -l   List the notes made in the current directory.
#   -s   List the notes made since the start of this week.
#        (Both combine: -l -s lists this week's notes here.)
#
# When only options are given, nothing is logged.

file="$HOME/todo.txt"
bydir=
byweek=
usage="usage: todo [-l] [-s] [note ...]"

while true; do
    case "$1" in
	-l) bydir=1; shift ;;
	-s) byweek=1; shift ;;
	-ls|-sl) bydir=1; byweek=1; shift ;;
	--) shift; break ;;
	-*) echo "$usage" >&2; exit 2 ;;
	*) break ;;
    esac
done

if test -n "$bydir" || test -n "$byweek"; then
    dir=
    since=
    if test -n "$bydir"; then
	dir="`pwd`"
    fi
    if test -n "$byweek"; then
	# Monday of the current week.
	since="`date -d \"-$(( \`date +%u\` - 1 )) days\" '+%Y-%m-%d'`"
    fi
    test -r "$file" || exit 0
    awk -F'\t' -v dir="$dir" -v since="$since" '
	dir != "" && $2 != dir { next }
	since != "" && substr($1, 1, 10) < since { next }
	{ print }
    ' "$file"
fi

if test $# -gt 0; then
    printf '%s\t%s\t%s\n' "`date '+%Y-%m-%d %H:%M:%S'`" "`pwd`" "$*" >> "$file"
fi
