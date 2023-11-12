#!/usr/bin/env bash

set -e
set -u
set -o pipefail
# set -x
source colortext.sh

clearVars() {
    unset i parentPath filebase filename suffix fullpath
}

gracefulExit() {
    clearVars
    exit 0
}

createNewBackup() {
    printf "How many $dirPath backups? $i\n"
    i=$(echo $(($i + 1)))
    newbackup="$parentPath/$filename-bak$i"
    printf "Add another backup $newbackup\n"
    gracefulExit
}

trap "gracefulExit" INT PWR QUIT TERM

case $# in
2)
    dirPath="$1"
    dirName="$2"
    if [ -e "$dirPath" ] && [ -r "$dirPath" ] && [ -d "$dirPath" ]; then
        printf "Directory to check:\t$dirPath\n"
        printf "Checking for backups to:\t$dirName\n\n"
        howManyBackups=0

        for file in $(ls "$dirPath"); do
            filebase=$(basename "$file")
            filename=${filebase%-*}
            suffix=${filebase##*-}
            fullpath="$dirPath$filebase"
            parentDir="$(dirname "$fullpath")"

            if [ "$filename" = "$dirName" ]; then
                if [ "$suffix" != "$dirName" ]; then
                    if [[ "$suffix" =~ bak([0-9]+)? ]]; then
                        printf "\nFound $fullpath\n"
                        printf "Base $filebase\n"
                        printf "Name $filename\n"
                        printf "Suffix $suffix\n"
                        printf "Parent $parentDir\n"
                        printf '%.0s-' {1..55}
                        printf "\n"

                        if [[ "$suffix" =~ bak([0-9]+)? ]]; then
                            howManyBackups=$(echo $(($howManyBackups + 1)))
                        fi
                    fi
                fi
            fi
        done
        printf "\nHow many backups do $dirName have? $howManyBackups\n"

        if [ "$howManyBackups" -eq 0 ]; then
            printf "Making new backup\n"
        elif [ "$howManyBackups" -gt 0 ]; then
            howManyBackups=$(echo $(($howManyBackups + 1)))
            newBackup="$parentDir/$filename-bak$howManyBackups"
            printf "Making new backup $newBackup\n"
        fi

    fi
    ;;
esac
