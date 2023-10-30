#!/bin/bash

target_dir="source/new"

extract_resources(){
	_resources="${1}"
	[ ! -d "${target_dir}" ] && mkdir -vp "${target_dir}"
	for resource in ${resources[*]};
	do
       		printf "\033[35mExtracting resource:\t\033[36m${resource}\033[0m\n"
        	pushd .
        	cd "$target_dir"
        	wget $resource
        	popd
	done
}

value_extractor(){
	value="${1}"
	_result=$(echo "${value}" | cut -d':' -f2 | cut -d'=' -f2)
	echo "${_result}"
}

view_resources(){
	_resources="${1}"
	for res in ${_resources[@]}
	do
		echo "${res}"
	done
}

usage(){
	printf "\033[36mUSAGE:\033[0m\n"
	printf "\033[32mExtract a minimized dataset\033[0m\n"
	printf "\033[35m$0 \033[34m--min --action=extract\033[0m\n"
	printf "\033[32mExtract the full dataset\033[0m\n"
	printf "\033[35m$0 \033[34m--full --action=extract\033[0m\n"
}

commands(){
	printf "\033[36mCOMMANDS:\033[0m\n"
	printf "\033[35mExtract from remote:\t\033[32mextract, pull\033[0m\n"
	printf "\033[35mShow file list\t\t\033[32mview, show\033[33m\n"
	echo;
}

help_menu(){
	printf "\033[36mExtract Sources\033[0m\n"
	printf "\033[35mExtract Minimal Set\t\033[32m[ -min, --min, --minimize ]\033[0m\n"
	printf "\033[35mExtract Full Set\t\033[32m[ -full, --full, --all ]\033[0m\n"
	echo;
	commands
	usage
	exit 0
}


for argv in $@
do
	case $argv in
		-h|-help|--help) help_menu;;
		-min|--min|--minimize) resources=$(cat complete_urls_list-minimized.txt | tr -d '\"');;
		-full|--full|--all) resources=$(cat complete_urls_list.txt | tr -d '\"');;
		--action=*|action:*) _action=$(value_extractor "${argv}")
	esac
done


case $_action in
	extract|pull) extract_resources "${resources[@]}";;
	view|show)
	if [ -n "${resources[@]}" ];
	then
		view_resources "${resources[@]}"
	else
		echo "Missing or invalid resource size was given. (i.e. --min or --full)"
	fi
	;;
	*) echo "Missing or invalid action was given!"
esac
