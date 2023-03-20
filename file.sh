#!/bin/bash
usagelimit=1

if [ ! -d "/media/conk/LOG" ]
then
	echo "LOG doesn't exit"
	exit 0
fi

usage=$(df --output=pcent /media/conk/LOG | grep -o '[0-9]*')

if [ ! -d "/media/conk/BACKUP" ]
then
	echo "BACKUP doesn't exit"
	exit 0
fi

if [ ! $usage -ge $usagelimit ]
then
	echo "LOG usage is less than $usagelimit%"
	exit 0
fi
if [ $usage -ge $usagelimit ]
then
	cd /media/conk/LOG
	list=()
	for file in $(ls -t | tail -n4)
	do
		if [ $file != "lost+found" ]
		then
			list+=( $file )
		fi
	done
	
	if [ ! ${#list[0]} -eq 0 ]
	then
		tar -czf /media/conk/BACKUP/archive.tar.gz ${list[@]}
		for file in /media/conk/LOG/${list[@]}
		do
			rm $file
		done
	else
		echo "Not enough file in LOG"
	fi
	echo "Script has finished successfully"
fi
