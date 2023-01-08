#!/usr/bin/env bash
set -x

target_dir="dataset"
target_encoding='utf-8'

error(){
	printf "\033[35mError:\t\033[31m${1}!\033[0m\n"
	exit 1
}

view_encoding(){
	for srcfile in ${@}
	do
		file -i "${srcfile}"
	done
}

refactor_encoding(){
	view_encoding ${@}
	[ ! -d "${target_dir}" ] && mkdir -v "${target_dir}"
	for srcfile in ${@}
	do
		target_file=$(basename "${srcfile}" | tr [:upper:] [:lower:])
		_currentEncoding=$(file -i ${srcfile} | awk '{print $3}' | cut -d'=' -f2 | tr [:lower:] [:upper:])
		printf "Changing Encoding from ${_currentEncoding} ${srcfile} to $target_encoding -> ${target_dir}/${target_file}\n"
		# Example:  iconv -f ISO-8859-1 -t UTF-8//TRANSLIT "${srcfile}" -o ${target}/a.csv
		case ${_currentEncoding} in
			"UNKNOWN-8BIT") iconv -t utf8 -sc ${srcfile} > ${target_dir}/${target_file};;
			*) iconv -f ${_currentEncoding} -t UTF-8//TRANSLIT ${srcfile} -o ${target_dir}/${target_file};;
		esac
	done
}

usage(){
	printf "USAGE:\n"
	printf "\033[34m# Change Encoding for all CSV files in 'current' directory\033[0m\n"
	printf "\033[35m$0 \033[32m--action=refactor --files=*.csv\033[0m\n"
	printf "\033[34m# Change Encoding for all CSV files in a 'target' directory\033[0m\n"
	printf "\033[35m$0 \033[32m--action=refactor --files=dataset/*.csv\033[0m\n"
	exit 0
}

commands(){
	printf "\033[36mCOMMANDS\033[0m\n"
	printf "\033[35mRefactor Encoding:\t\033[32mrefactor, encoding\033[0m\n"
	usage
	exit 0
}

help_menu(){
	printf "\033[36mPreClean Tool\033[0m\n"
	printf "\033[35mRefactor Encoding\t\033[32m[ action:[COMMAND], --action=[COMMAND] ]\033[0m\n"
	printf "\033[35mShow Commands\t\t\033[32m[ -commands, --commands ]\n"
	printf "\033[35mShow Usage\t\t\033[32m[ -usage, --usage ]\n"
	commands
	exit 0
}

for args in $@
do
	case $args in
		action:*|--action=*) _action=$(echo "$args" | cut -d'=' -f2 | cut -d':' -f2);;
		file:*|files:*|--file=*|--files=*) _files=$(echo "$args" | cut -d'=' -f2 | cut -d':' -f2);;
		-usage|--usage) usage;;
		-commands|--commands) commands;;
		-h|help|-help|--help) help_menu;;
	esac
done

case $_action in
	refactor|encoding) refactor_encoding ${_files[@]};;
esac


