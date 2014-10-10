#!/bin/bash

target_branch=$1

status=`execute "git checkout $target_branch"`
echo $status

status=`execute "git merge origin/$target_branch"`
echo $status

status=`execute "git merge origin/$source_branch"`
echo $status

status=`execute "git push origin $target_branch"`
echo $status

status=`execute "git checkout $current_branch"`
echo $status

echo "Zmiany wrzucone"