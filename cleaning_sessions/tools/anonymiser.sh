#!/bin/bash

BLACKLIST="config/blacklist.txt"
OUTPUT_DIR="anonymiser_data"
OUTPUT_FILE="${OUTPUT_DIR}/ignore_employee_names.txt"

error(){
	printf "\033[35mError:\t\033[31m${1}.\033[0m\n"
	exit 1
}

extract_value(){
	echo "${1}" | cut -d':' -f2 | cut -d'=' -f2
}


for argv in $@;
do
	case $argv in
		--dir=*|dir:*) _dirname=$(extract_value $argv);;		
	esac
done

# Create empty array
_names=()
# Create output directory
[ ! -d "${OUTPUT_DIR}" ] && mkdir -v "${OUTPUT_DIR}"

if [ -e "${BLACKLIST}" ];
then
	for _result in $(find ${_dirname} -type f -exec egrep -r -h 'Name ' {} \;)
	do
		if [ -z "$(printf ${_result} | egrep -E -i -f ${BLACKLIST})" ];
		then
			echo "${_result}"
			if [ $(printf "${_result}" | wc -c ) -gt 2 ];
			then
				names+=( "$(printf ${_result} | sed 's/://g' | sed 's/(//g' | sed 's/)//g')" )
			fi
		else
			printf "\033[36mRunning, extraction analysis..."
			clear
		fi
	done
	[ -e "${OUTPUT_FILE}" ] && rm -v "${OUTPUT_FILE}"
	printf "%s\n" ${names[*]} | sort -u | tee -a "${OUTPUT_FILE}"
else
	error "Missing or unable find file ${BLACKLIST}"
fi
