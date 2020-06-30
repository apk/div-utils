#!/bin/sh
mkdir -p /tmp/.ak/ffprff
cd /tmp/.ak/ffprff
for i in *; do
    pidfile="$i/.pid"
    pid="$i"
    if test -r "$pidfile"; then
	# echo "Pid $i: `cat "$pidfile"`"
	pid="`cat "$pidfile"`"
	if kill -0 "$pid" >/dev/null 2>&1; then
	    : echo there $i $pid
	else
	    rm -rf ./"$i"
	fi
    fi
done
( profile="/tmp/.ak/ffprff/$BASHPID"
    rm -rf "$profile"
    mkdir -p "$profile"
    cd "$profile"
    while test $# -gt 0; do
	case X"$1" in
	    X--moo)
		echo 'user_pref("general.smoothScroll", false);' >>user.js
		shift
		;;
	    X--socks=*)
		port=`expr "x$1" : '[^=]*=\(.*\)'`
		echo 'user_pref("network.proxy.socks", "localhost");' >>user.js
		echo 'user_pref("network.proxy.socks_port", '"$port"');' >>user.js
		echo 'user_pref("network.proxy.socks_remote_dns", true);' >>user.js
		echo 'user_pref("network.proxy.type", 1);' >>user.js
		shift
		;;
	    *)
		break
		;;
	esac
    done

    echo 'user_pref("browser.ctrlTab.recentlyUsedOrder", false);' >>user.js

    firefox --private-window --profile "$profile" "$@" &
   echo "$!" >"$profile"/.pid
) >/dev/null 2>&1 </dev/null
