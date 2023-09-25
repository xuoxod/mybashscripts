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
    elif [ ! -e "$filepath" ]; then
        text="$filepath does not exist"
        white text
    elif [ ! -f "$filepath" ]; then
        text="$filepath is not a file"
        white text
    elif [ ! -w "$filepath" ]; then
        text="$filepath is not writable"
        white text
    else
        filebase=$(basename "$filepath")
        filename=${filebase%.*}
        extension=${filebase##*.}

        if [ "$filename" != "motd" ]; then
            text="This program will only write to the /etc/motd file"
            white text
        else
            text=$(figlet -cptW "$text")
            blue text
        fi
    fi
    ;;

*)
    usage
    ;;
esac
