#!/bin/sh
profdir="/tmp/.$USER/fifresh"
mkdir -p "profdir"
cd "profdir"
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
profile="$profdir/$$-`date +%s`"
rm -rf "$profile"
mkdir -p "$profile"
cd "$profile"

user_pref() {
    echo 'user_pref("'"$1"'", '$2');' >>user.js
}

verb=false
fifo="$HOME/firefox/firefox"

test -x "$fifo" || fifo=firefox

moo=false

case "$DISPLAY" in
*:[12][0-9].[0-9])
    moo=true
    ;;
esac

while test $# -gt 0; do
    case X"$1" in
	X--esr)
	    fifo="$HOME/esr/firefox/firefox"
	    shift
	    ;;
	X--fifo=*)
	    fifo="`expr "x$1" : '[^=]*=\(.*\)'`"
	    shift
	    ;;
	X/*)
	    if test -x "$1"; then
		fifo="$1"
		shift
	    else
		break
	    fi
	    ;;
	X-v)
	    verb=true
	    shift
	    ;;
	X--moo)
	    moo=true
	    shift
	    ;;
	X-[0-9][0-9][0-9]|X-[0-9][0-9][0-9][0-9]|X-[0-9][0-9][0-9][0-9][0-9])
	    port=`expr "x$1" : '[^-]*-\(.*\)'`
	    user_pref "network.proxy.socks" '"localhost"'
	    user_pref "network.proxy.socks_port" "$port"
	    user_pref "network.proxy.socks_remote_dns" true
	    user_pref "network.proxy.type" 1
	    shift
	    ;;
	X--socks=*)
	    port=`expr "x$1" : '[^=]*=\(.*\)'`
	    user_pref "network.proxy.socks" '"localhost"'
	    user_pref "network.proxy.socks_port" "$port"
	    user_pref "network.proxy.socks_remote_dns" true
	    user_pref "network.proxy.type" 1
	    shift
	    ;;
	X--)
	    shift
	    break
	    ;;
	X-*)
	    echo "Bad opt: '$1'"
	    exit 9
	    ;;
	*)
	    break
	    ;;
    esac
done

if $moo; then
    user_pref "general.smoothScroll" false
fi

user_pref "browser.ctrlTab.recentlyUsedOrder" false
user_pref "datareporting.policy.dataSubmissionEnabled" false

if $verb; then
    echo '= user.js'
    cat user.js
    echo '= command'
    echo "$fifo" --no-remote --private-window --profile "$profile" "$@"
fi
"$fifo" --no-remote --private-window --profile "$profile" "$@" >log 2>&1 </dev/null &
echo "$!" >.pid
