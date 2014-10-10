#!/bin/bash

target_branch=$1

execute "git checkout $target_branch"

execute "git merge origin/$target_branch"

execute "git merge $source_branch"

execute "git push origin $target_branch"

execute "git checkout $current_branch"
