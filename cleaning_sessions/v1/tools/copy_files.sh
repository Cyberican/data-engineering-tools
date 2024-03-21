#!/bin/bash

initial_dataset='initial_dataset'
target_dir="cleaning"

[ ! -d "${target_dir}" ] && mkdir -v "${target_dir}"

for f in $(find ${initial_dataset} -type f -name "*.docx");
do
	cp -a -v $f ${target_dir}/$(basename "${f}" | sed "s/ //g")
	break
done

