#! /usr/bin/bash

set -e
set -u
source colorprint.sh

clearVars() {
    unset color text
}

gracefulExit() {
    clearVars
    exit 0
}

usage() {
    text='bannertext <"Double Quoted Text">\n'
    white text
    text='bannertext <"Double Quoted Text"> <Path to banner file>\n'
    white text
}

trap "gracefulExit" INT PWR QUIT TERM

case $# in
1)
    text=$1
    if [ -z "$text" ]; then
        text="Argument is empty"
        orange text
    else
        color="39"
        custom color text
    fi
    ;;

2)
    text=$1
    filepath=$2
    if [ -z "$text" ]; then
        text="Argument is empty"
    elif [ ! -x "$filepath" ] || [ ! -w "$filepath" ] || [ ! -f "$filepath" ]; then
        text="$filepath does not exist or is not writable or is not a file\n"
        white text
    else
        printf "Howdy Hay!!!"
    fi
    ;;

*)
    usage
    ;;
esac
