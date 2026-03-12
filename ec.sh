#!/bin/sh
# Note: 'emacsclient -c -n "@$"' for a new GUI frame here. Or 'ecw'.
exec emacsclient -t -a vi "$@"
