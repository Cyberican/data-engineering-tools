#!/bin/bash

target_dir="example_files"

removeAll(){
if [ -d "$target_dir" ];
then
	find "${target_dir}" -type f -delete
	find . -type d -name "$target_dir" -delete
fi
}

createDirectory(){
if [ ! -d "${target_dir}" ];
then
	mkdir -v $target_dir
else
	printf "Directory ($target_dir) was already created.\n"
fi
}

createDocs(){
# Create directories
createDirectory

_files=( 'Test%%WA_CT_Jon_Smith.docx' 'WA_CT_Max_Mustermann.docx' 'WA_CT_Jane_Smith.docx' 'WA_CT_Harry_Meagans.docx' )
_files+=( 'WA_CT_Tom_Hands.docx' 'DD%%WA_CT_Patrick%%Wilmar.docx' 'WA_CT_Smith.docx' 'WA_CT_ErickLudwig.docx' )

for (( i=0; i < 15; i++ ))
do
	for f in ${_files[@]};
	do
		_date=$(date '+%s')
		_random=${RANDOM:0:1}
		printf "${_random}\n"
		case ${_random} in
			0|1) fp=$(echo "${f}" | sed "s|\.docx|-${_date}-DE.docx|g");;
			2) fp=$(echo "${f}" | sed "s|\.docx|-${_date}-EN.docx|g");;
			3) fp=$(echo "${f}" | sed "s|\.docx|-${_date}-SP.docx|g");;
			4) fp=$(echo "${f}" | sed "s|\.docx|-SP.docx|g");;
			5) fp=$(echo "${f}" | sed "s|\.docx|-${_date}.docx|g");;
			*) fp=$(echo "${f}" | sed "s|\.docx|.docx|g");;
		esac
		_modify="$(echo ${fp} | sed 's|%%| |g')"
		printf "Creating file: ${_modify}\n"
		touch "${target_dir}/${_modify}"
	done
done
}

usage(){
	printf "\033[36mUSAGE:\033[0m\n"
	printf "\033[35m$0 \033[32m--action=create-docs\033[0m\n"
	exit 0
}

commands(){
	printf "\033[36mCOMMAND:\033[0m\n"
	printf "\033[35mCreate Directory\t\033[32m[ create-dir ]\033[0m\n"
	printf "\033[35mCreate Docs\t\t\033[32m[ create-docs ]\033[0m\n"
	printf "\033[35mRemove all\t\t\033[32m[ remove-all ]\033[0m\n"
	printf "\n"
}

help_menu(){
	printf "\033[36mCreate Files\033[0m\n"
	printf "\033[35mExecute Command\t\t\033[32m[ action:[COMMAND], --action=[COMMAND] ]\033[0m\n"
	printf "\033[35mScript Usage\t\t\033[32m[ -usage, --usage ]\033[0m\n"
	printf "\033[35mHelp Menu\t\t\033[32m[ -h, -help, --help ]\033[0m\n"
	printf "\n"
	commands
	usage
	exit 0
}

for args in $@
do
	case $args in
		action:*|--action=*) _action=$(echo $args | cut -d'=' -f2 | cut -d':' -f2);;
		-usage|--usage) usage;;
		-h|-help|--help) help_menu;;
	esac
done

case $_action in
	remove-all) removeAll;;
	create-dir) createDirectory;;
	create-docs) createDocs;;
esac
