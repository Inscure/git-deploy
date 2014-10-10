#!/bin/bash

current_branch=`git rev-parse --abbrev-ref HEAD`

commands="git fetch"

echo "$commands"

status=`$commands`

a=`git rev-parse master`
b=`git rev-parse origin/master`

commands2="git merge origin/master"
echo "$commands2"
status2=`$commands2`

if [[ -z $status2 ]]; then
     echo "Wystąpił błąd"
else
    if [ $a != $b ]; then
        commands3="git push origin $current_branch"
        echo "$commands3"
        status3=`$commands3`

        if [[ -z $status3 ]]; then
            echo "Wystąpił błąd"
        else
            echo "Push zakończony sukcesem"
        fi;
    else
        echo "Twoje zmiany zostały już wysłane do repozytorium"
    fi;
fi;
