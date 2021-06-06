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
