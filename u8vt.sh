#!/bin/sh
ccol=yellow
xcc='ff0'
bg=black
xbg=000
fg=white
xfg=fff
xfn='Misc Fixed:style=SemiCondensed:pixelsize=13'
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
    xfn='monospace:size=10'
    shift
    ;;
  -11)
    xfn='monospace:size=10'
    shift
    ;;
  -f)
    xfn=''
    shift
    ;;
  -b)
    xbg="`ruby -e 'puts %w{ 111 121 211 112 }.shuffle[0]'`"
    bg="#$xbg"
    shift
    ;;
  -c)
    xbg="`ruby -e 'puts %w{ 401 036 306 033 }.shuffle[0]'`"
    bg="#$xbg"
    shift
    ;;
  -w)
    xbg="`ruby -e 'puts %w{ efd fed efd fdd }.shuffle[0]'`"
    bg="#$xbg"
    xfg=000
    fg=black
    ccol=blue
    xcc='00f'
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
if test -n "${WAYLAND_DISPLAY:-}"; then
  # echo "xfg=$xfg xbg=$xbg xcc=$xcc "
  f() {
    echo "$*" | sed 's,.,&&,g'
  }
  if test -x /usr/bin/foot; then
    # -o colors.alpha=0.7 &
    set --
    if test -n "$xfn"; then
         set -- "$@" -o "font=$xfn"
    fi
    set -- "$@" -o colors.background="`f $xbg`"
    set -- "$@" -o colors.foreground="`f $xfg`"
    set -- "$@" -o cursor.color="`f $xfg` `f $xcc`"
    # echo "$@"
    exec aenv -U LANG LC_ALL=en_AU.utf8 /usr/bin/foot "$@" 2>/dev/null &
  elif test -x /usr/bin/kitty; then
    set -- -o text_composition_strategy=1.5' '0
    #if test -n "$xfn"; then
    #     set -- "$@" -o "font=$xfn"
    #fi
    set -- "$@" -o background="#`f $xbg`"
    set -- "$@" -o foreground="#`f $xfg`"
    set -- "$@" -o cursor="#`f $xfg`"
    # echo "$@"
    # „For your convenience, your terminal emulator will now contact
    #  seventeen D-Bus services.“ The desktop integration is mandatory.
    # Please assume the party escort submission position. - Glados
    exec aenv -U LANG LC_ALL=en_AU.utf8 /usr/bin/kitty "$@" 2>/dev/null &
  else
    echo "No foot nor kitty..."
  fi
elif test -n "${DISPLAY:-}"; then
  for i in urxvt xterm; do
    term=/usr/bin/"$i"
    if test -x "$term"; then break; fi
  done
exec aenv -U LANG LC_ALL=en_AU.utf8 "$term" +sb -cr "$ccol" -bg "$bg" -fg "$fg"$args "$@" -e bash &
else
  echo "Neither kind of DISPLAY available."
fi
