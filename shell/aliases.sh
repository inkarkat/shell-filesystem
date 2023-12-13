#!/bin/sh source-this-script

umount()
{
    local lastArg="${!#}"
    if [ -d "$lastArg" ]; then
	command umount "$@" || {
	    status=$?
	    withUserNotify --title "umount $lastArg" --console --gui -- showFilesInUse "$lastArg"
	    return $status
	}
    else
	command umount "$@"
    fi
}

# Automatically cd into the created "virtual" directory, and create a
# "zipumount" alias.
zipmount()
{
    typeset tmpDir=
    tmpDir="$(command zipmount "$@")" || return $?
    if [ "$tmpDir" ]; then
	if [ -d "$tmpDir" ]; then
	    pushd "$tmpDir" >/dev/null
	    alias zipumount="if ! popd >/dev/null 2>&1; then inside '$tmpDir' && command cd; fi; zipmount --unmount '$tmpDir'"
	    echo >&2 '    zipumount'
	else
	    # Handle help output.
	    printf '%s\n' "$tmpDir"
	fi
    fi
}
