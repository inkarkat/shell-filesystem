#!/bin/sh source-this-script

umount()
{
    local lastArg="${!#}"
    if [ -d "$lastArg" ]; then
	command umount "$@" || {
	    status=$?
	    showFilesInUse --title "umount $lastArg" -- "$lastArg"
	    return $status
	}
    else
	command umount "$@"
    fi
}
