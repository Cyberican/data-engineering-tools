#!/bin/bash

# Stop the main program

ps ax | egrep 'main.py' | egrep -v 'grep' | awk '{print $1}' | xargs sudo kill -9 2> /dev/null
ps aux | egrep 'doc2pdf' | grep -v 'grep' | awk '{print $1}' | sudo xargs kill -9 2> /dev/null

if [ -n "$(pgrep soffice.bin)" ];
then
	printf "Killing, processes $(pgrep soffice.bin | tr '\n' ' ')\n"
	sudo kill -9 $(pgrep soffice.bin)
else
	printf "No converter daemons were found.\n"
fi
