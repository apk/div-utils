#!/bin/sh
ccol=yellow
bg=black
fg=white
case "`hostname`" in
    socbl965)
	ccol=red
	;;
    socvm102)
	ccol=orange
	;;
    socvm104)
	ccol=pink
	;;
esac
args=""
while test $# -gt 0; do
case "$1" in
  -10)
    args="$args -fn 10x20"
    shift
    ;;
  -b)
    bg="`ruby -e 'puts %w{ #111 #121 #211 #112 }.shuffle[0]'`"
    shift
    ;;
  -c)
    bg="`ruby -e 'puts %w{ #401 #036 #306 #033 }.shuffle[0]'`"
    shift
    ;;
  -w)
    bg="`ruby -e 'puts %w{ #efd #fed #efd #fdd }.shuffle[0]'`"
    fg=black
    ccol=blue
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    break
    ;;
esac
done
for i in urxvt xterm; do
  term=/usr/bin/"$i"
  if test -x "$term"; then break; fi
done

exec aenv -U LANG LC_ALL=en_AU.utf8 "$term" +sb -cr "$ccol" -bg "$bg" -fg "$fg"$args "$@" -e bash &
