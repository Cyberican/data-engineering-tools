#!/bin/bash

error(){
	printf "\033[35mError:\t\033[31m${1}!\033[0m\n"
	exit 1
}

filename="${1}"

if [ -f "$filename" ];
then
	cat "${filename}" | tr ' ' '\n' | tr -d ',' | tr -d '.' | tr -d '(' | tr -d ')' | tr -d '„' | tr [:upper:] [:lower:] | sort -u
else
	error "Missing or unable to find file"
fi
