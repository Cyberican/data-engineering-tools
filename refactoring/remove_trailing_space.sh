#!/bin/bash

# Get the filename from the command line arguments
filename=$1

# function will remove all trailing lines
# and replace old file
remove_trailing_spaces() {
    # Write the modified lines to the file
    sed -i 's/[ \t]*$//g' ${1}
    cat -veT ${1}
}

if [ -f "$filename" ];
then
	cat -veT $filename
	# Call the function to remove the trailing lines
	remove_trailing_spaces $filename
fi
