#!/bin/bash
usage=$(df —output=pcent /media/conk/LOG/ | grep -o '[0-9]*')
if [ $usage -ge 1 ]
then
tar -czvf /media/conk/BACKUP/test.tar.gz /media/conk/LOG
for file in /media/conk/LOG/*
do
rm $file
done
fi