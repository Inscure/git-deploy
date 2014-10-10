#!/bin/bash

current_branch=`git rev-parse --abbrev-ref HEAD`

function isUp2Date {
    local a=`git rev-parse master`
    local b=`git rev-parse origin/master`

    if [ $a == $b ]; then
        echo 1;
    else
        echo 0;
    fi;
}

function execute {
    echo "$@"
    local status2=`$@`
}

function toCommit {
    local status=`git status --porcelain`

    if [[ -z $status ]]; then
        echo 0;
    else
        echo 1;
    fi;
}



# Weryfikacja, czy są jakieś zmiany do zatwierdzenia
if [ `toCommit` -eq 1 ]; then
    echo "Znaleziono zmiany, które nie są zatwierdzone."
    exit;
fi;

status=`execute "git fetch"`
echo "$status"

# Aktualizacja bieżącego brancha o branch master
status=`execute "git merge origin/master"`
echo "$status"

if [ `toCommit` -eq 1 ]; then
    echo "Rozwiąż konflikt"
    exit;
fi;

# Aktualizacja bieżącego brancha o zmiany wprowadzone w branchu zdalnym
if [ "$current_branch" != "master" ]; then

    status=`execute "git merge origin/$current_branch"`
    echo "$status"

    if [ `toCommit` -eq 1 ]; then
        echo "Rozwiąż konflikt"
        exit;
    fi;

fi;

# Push zmian
if [ `isUp2Date` -eq 0  ]; then
    status=`execute "git push origin $current_branch"`
    echo "$status"

    if [[ `isUp2Date` -eq 0 ]]; then
        echo "Wystąpił błąd"
    else

        if [ "$#" -gt 0 ]; then
            basedir="$(dirname "$0")"
            "$basedir/deploy.sh"
        else
            echo "Push zakończony sukcesem"
        fi;
 
    fi;
else
    echo "Twoje zmiany zostały już wysłane do repozytorium"
fi;
