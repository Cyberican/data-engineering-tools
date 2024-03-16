#!/bin/bash

archive_dir='.archives'
dirname='cleaning'
date="$(date '+%s')"
archive_name="${dirname}-${date}.7z"

logger(){
	printf "\033[1;35m${1}\033[0m\n"
}

error(){
	printf "\033[35mERROR:\t\033[31m${1}\033[0m\n"
	exit 1
}

warning(){
	printf "\033[35mWARNING:\t\033[33m${1}\033[0m\n"
}

[ ! -d "${archive_dir}" ] && logger "Creating, archive directory" && mkdir -v ${archive_dir}

if [ -d "${dirname}" -a -d "${archive_dir}" ];
then
	if [ -n "$(ls ${dirname})" ];
	then
		logger "Creating archive, ${dirname} workspace session directory..."
		7z a ${archive_name} ${dirname}
		logger "Archiving, workspace session files to ${archive_dir}."
		mv -v ${archive_name} ${archive_dir}/
		logger "Removing, workspace session files."
		find cleaning/ -type f -delete
	else
		logger "No current session files in workspace."
	fi
else
	warning "Unable to locate the ${dirname} or ${archive_dir} directory"
fi
