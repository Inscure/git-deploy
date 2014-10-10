#!/bin/bash

current_branch=`git rev-parse --abbrev-ref HEAD`

if [ $# -gt 1 ]; then
    source_branch="$2"
else
    source_branch="$current_branch"
fi;

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
    exec $@
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

if [ $current_branch != $source_branch ]; then
    status=`execute "git checkout $source_branch"`
    echo "$status"
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
if [ "$source_branch" != "master" ]; then

    status=`execute "git merge origin/$source_branch"`
    echo "$status"

    if [ `toCommit` -eq 1 ]; then
        echo "Rozwiąż konflikt"
        exit;
    fi;

fi;

# Push zmian
if [ `isUp2Date` -eq 0  ]; then
    status=`execute "git push origin $source_branch"`
    echo "$status"

    if [[ `isUp2Date` -eq 0 ]]; then
        echo "Wystąpił błąd"
        exit
    fi;

    echo "Zmiany z brancha $source_branch zostały zamieszczone w zdalnym repozytorium."
else
    echo "Bieżący branch jest aktualny"
fi;

if [ "$#" -gt 0 ]; then
    basedir="$(dirname "$0")"
    source "$basedir/merge.sh"
else
    echo "Push zakończony sukcesem"
fi;

if [ $current_branch != $source_branch ]; then
    status=`execute "git checkout $current_branch"`
    echo "$status"
fi;

if [ $current_branch != $source_branch ]; then
    status=`execute "git checkout $current_branch"`
    echo "$status"
fi;
