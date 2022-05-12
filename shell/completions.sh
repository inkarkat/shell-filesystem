#!/bin/bash source-this-script

_chx_complete()
{
    local IFS=$'\n'
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"

    typeset -a files=()
    readarray -t files < <(compgen -f -- "$cur")

    local filespec; for filespec in "${files[@]}"
    do
	[ ! -f "$filespec" -o ! -x "$filespec" ] && COMPREPLY+=("$filespec")
    done

    [ ${#COMPREPLY[@]} -gt 0 ] && readarray -t COMPREPLY < <(printf "%q\n" "${COMPREPLY[@]}")
}
_chX_complete()
{
    local IFS=$'\n'
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"

    typeset -a files=()
    readarray -t files < <(compgen -f -- "$cur")

    local filespec; for filespec in "${files[@]}"
    do
	[ ! -f "$filespec" -o -x "$filespec" ] && COMPREPLY+=("$filespec")
    done

    [ ${#COMPREPLY[@]} -gt 0 ] && readarray -t COMPREPLY < <(printf "%q\n" "${COMPREPLY[@]}")
}
complete -o filenames -F _chx_complete chx
complete -o filenames -F _chX_complete chX


# mount: Override the default completion to offer the user's mount points
# directly while still delivering the original mount options.
_mount_complete()
{
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"

    local userMountDirspec="/media/${USER}"

    if [ "${cur#${userMountDirspec}/}" = "$cur" ]; then
	COMPREPLY=("${userMountDirspec}"/*${cur}${cur:+*})
	[ "${COMPREPLY[*]}" = "${userMountDirspec}/*${cur}${cur:+*}" ] && COMPREPLY=()   # Emulate shopt -qs nullglob
    else
	readarray -t COMPREPLY < <(compgen -d -- "$cur")
    fi

    if [ ${#COMPREPLY[@]} -gt 0 ]; then
	readarray -t COMPREPLY < <(printf "%q\n" "${COMPREPLY[@]}")
	return
    fi

    "${COMP_DELEGATE_FUNCTION:?}" "${COMP_DELEGATE_COMMAND:?}" "${@:2}"
}
completeWithDelegationTo mount -F _mount_complete mount
completeWithDelegationTo umount -F _mount_complete umount
