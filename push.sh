#!/bin/bash

current_branch=`git rev-parse --abbrev-ref HEAD`



function isUp2Date {
    a=`git rev-parse master`
    b=`git rev-parse origin/master`

    if [ $a == $b ]; then
        echo 1;
    else
        echo 0;
    fi;
}

function execute {
    echo "$@"
    status2=`$@`
}

status=`execute "git fetch"`

echo "$status"


status=`execute "git merge origin/master"`
echo "$status"

status=`execute "git merge origin/$current_branch"`
echo "$status"

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

