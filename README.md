# Diverse utils

These are some random utilities I find useful.

## `run-on-change`

Poll modification dates of a set of files, and
run a set of command when there was a change.

The last of the commands may run indefinitely
(i.e. a server process) and is killed when
the next change is detected.

`run-on-change my.go -- go build my.go -- ./my`
build and restarts your go binary every time
you save it from the editor.

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

It currently also does some `PATH` magic that
makes it unusable in any non-mine-like setup.
