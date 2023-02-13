#!/bin/bash

resources=$(cat complete_urls_list.txt | tr -d '\"')
target_dir="source/new"

[ ! -d "${target_dir}" ] && mkdir -vp "${target_dir}"

for resource in ${resources[*]};
do
        printf "\033[35mExtracting resource:\t\033[36m${resource}\033[0m\n"
        pushd .
        cd "$target_dir"
        wget $resource
        popd
done
