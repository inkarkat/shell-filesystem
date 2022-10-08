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
