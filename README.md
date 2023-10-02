# Diverse utils

These are some random utilities I find useful.

## `run-on-change`

Poll modification dates of a set of files, and
run a sequence of commands when there was a change.

The last one of the commands may run indefinitely
(i.e. a server process) and is killed when
the next change is detected.

`run-on-change my.go -- go build my.go -- ./my`
builds and restarts your go binary every time
you save it from the editor.

If `run-on-change` is invoked with a single
argument that is taken as a file, and the token
`run-on-change` must appear in the first dozen lines,
followed by arguments. Thus you can put the actual
command into the file you are testing. In that line,
`%` signs are replaced with the base name of the
containing file, so `# run-on-change % -- ruby %` works.
Also, the current directory is changed to the directory
containing the single file.

File names in the dependents list can be globs
(on the command line as well as in a `run-on-change`
line in a file), so `run-on-change **/*.rb -- ruby main.rb`
will rerun your app whenever any ruby file changes.

The option `--no-kill` disables active killing of the
last command on a new file change, a new run of the
command sequence then only starts when the last command
voluntarily terminates.

The option `--abs` prevents the directory change in the
single-file-name mode; and `%` are replaced by the full
file name.

## `fifresh`

Run a fresh instance of firefox with a freshly made profile.
(Bookmarking is obviously pointless in there.) Has a few options
to tweak the `user.js` configuration before starting firefox on it.

All arguments from the first non-option or after a `--`
are passed to firefox.

On start, cleans up old profiles (where the browser has
terminated) left in `/tmp`.

Uses `$HOME/firefox/firefox` by default; `firefox` if that
doesn't exist, and `$HOME/esr/firefox/firefox` with `--esr`.
`--fifo=some` executes `some` for starting firefox.

`--moo` disables smooth scrool (good for remote).

`-12345` (any number) sets the profile to use a socks5
proxy on the given ports. (Handy with `ssh -D 12345`.)

`-v` makes it show the command executed.

Options:

* `-v`: Show generated `user.js` and firefox invocation.
* `--moo`: Disable smooth scroll.
* `-N`, `--socks=N`: Use a socks5 proxy at the given port on localhost. N must be three to five digits.
* `--`: Stop option processing and pass remaining args to firefox.

## `g`

A `go` wrapper. Has a few options to make
cross-compilation easy, and allows
location-specific `GOPATH`/`GOBIN`/`PATH`
settings.

Options:

* `-win`: Cross-compile for windows.
* `-arm`: Cross-compile for raspbian.
* `-netarm`: Cross-compile for netbsd on bananapi.

It then looks for a file `.gopath` in the current
and any parent directories, set `GOPATH` to
that directory and `GOBIN` to its `bin` subdirectory,
and then invoked `go` with the same arguments
except for the options taken above.

It currently also does some `PATH` magic if
`"$HOME"/buildery/gobuild` exists - it then
will put its `g/bin` first in `PATH`.
([Buildery](https://github.com/apk/buildery)
bootstraps go from sources.)
