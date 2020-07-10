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

while test $# -gt 0; do
    case X"$1" in
	X-v)
	    verb=true
	    shift
	    ;;
	X--moo)
	    user_pref "general.smoothScroll" false
	    shift
	    ;;
	X-[0-9][0-9][0-9]|X-[0-9][0-9][0-9][0-9]|X-[0-9][0-9][0-9][0-9][0-9])
	    port="$1"
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
	--)
	    shift
	    break
	    ;;
	-*)
	    echo "Bad opt: '$1'"
	    exit 9
	    ;;
	*)
	    break
	    ;;
    esac
done

user_pref "browser.ctrlTab.recentlyUsedOrder" false
user_pref "datareporting.policy.dataSubmissionEnabled" false

if $verb; then
    echo '= user.js'
    cat user.js
    echo '= command'
    echo firefox --no-remote --private-window --profile "$profile" "$@"
fi
firefox --no-remote --private-window --profile "$profile" "$@" >log 2>&1 </dev/null &
echo "$!" >.pid
