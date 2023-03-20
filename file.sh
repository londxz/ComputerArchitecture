#!/bin/bash
usagelimit=0
i=1
N=4

if [ ! -d "/media/conk/LOG" ]
then
	echo "LOG doesn't exit"
	exit 0
fi

if [[ ! $logusage -ge $usagelimit ]]
then
	echo "LOG usage is less than $usagelimit%"
	exit 0
fi

logusage=$(df --output=pcent /media/conk/LOG | grep -o '[0-9]*')

if [ ! -d "/media/conk/BACKUP" ]
then
	echo "BACKUP doesn't exit"
	exit 0
fi

backupusage=$(df --output=pcent /media/conk/BACKUP | grep -o '[0-9]*')

if [ $backupusage -eq 100 ]
then
	echo "BACKUP is full"
	exit 0
fi

if [ $logusage -ge $usagelimit ]
then
	cd /media/conk/LOG
	list=()
	for file in $(ls -t | tail -n$N)
	do
		if [ $file != "lost+found" ]
		then
			list+=( $file )
			i=$((i + 1))
		fi
	done
	if [ ! ${#list[0]} -eq 0  ] && [[ $i -ge $N ]]
	then
		tar -czf /media/conk/BACKUP/archive.tar.gz ${list[@]}
		for file in /media/conk/LOG/${list[@]}
		do
			rm $file
		done
	else
		echo "Not enough files in LOG"
		exit 0
	fi
	echo "Success"
fi
