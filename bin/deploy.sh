#!/bin/bash

function current {
    echo `git rev-parse --abbrev-ref HEAD`
}

current_branch=$(current)

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
    printf "\n\e[31m$@\e[0m\n"
    echo `$@`
    printf "\n"
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
    printf "Znaleziono zmiany, które nie są zatwierdzone.\n"
    exit;
fi;

if [ $current_branch != $source_branch ]; then
   execute "git checkout $source_branch"
fi;

execute "git fetch"

# Aktualizacja bieżącego brancha o branch master
execute "git merge origin/master"

if [ `toCommit` -eq 1 ]; then
    printf "Rozwiąż konflikt\n"
    exit;
fi;

# Aktualizacja bieżącego brancha o zmiany wprowadzone w branchu zdalnym
if [ "$source_branch" != "master" ]; then

    execute "git merge origin/$source_branch"

    if [ `toCommit` -eq 1 ]; then
        printf "Rozwiąż konflikt\n"
        exit;
    fi;

fi;

# Push zmian
if [ `isUp2Date` -eq 0  ]; then
    execute "git push origin $source_branch"

    if [[ `isUp2Date` -eq 0 ]]; then
        printf "Wystąpił błąd\n"
        exit
    fi;

    printf "Zmiany z brancha $source_branch zostały zamieszczone w zdalnym repozytorium.\n"
else
    printf "Bieżący branch jest aktualny\n"
fi;

if [ "$#" -gt 0 ]; then
    basedir="$(dirname "$0")"
    source "$basedir/merge.sh"
fi;

if [ $current_branch != $(current) ]; then
    execute "git checkout $current_branch"
fi;

printf "Push zakończony sukcesem\n"
