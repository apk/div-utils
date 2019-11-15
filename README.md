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
command into the file you are testing.

File names in the dependents list can be globs
(on the command line as well as in a `run-on-change`
line in a file), so `run-on-change **/*.rb -- ruby main.rb`
will rerun your app whenever any ruby file changes.
(The glob itself is only evaluated once at startup, though.)

The option `--no-kill` disables active killing of the
last command on a new file change, a new run of the
command sequence then only starts when the last command
voluntarily terminates.

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
