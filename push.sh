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

if [ `toCommit` ]; then
    echo "Znaleziono zmiany, które nie są zacommitowane. Zacommituj zmiany."
    exit;
fi;

status=`execute "git fetch"`
echo "$status"

status=`execute "git merge origin/master"`
echo "$status"

if [ `toCommit` ]; then
    echo "Rozwiąż konflikt"
    exit;
fi;

status=`execute "git merge origin/$current_branch"`
echo "$status"

if [ `toCommit` ]; then
    echo "Rozwiąż konflikt"
    exit;
fi;


if [[ -z $status ]]; then
     echo "Wystąpił błąd"
else
    if [ `isUp2Date` -eq 0  ]; then
        status=`execute "git push origin $current_branch"`
        echo "$status"

        if [[ `isUp2Date` -eq 0 ]]; then
            echo "Wystąpił błąd"
        else
            echo "Push zakończony sukcesem"
        fi;
    else
        echo "Twoje zmiany zostały już wysłane do repozytorium"
    fi;
fi;


