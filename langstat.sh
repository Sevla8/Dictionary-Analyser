#!/bin/bash

# langstat.sh : give statistics on letter occurrences in a specific language
# Usage : langstat.sh <dictionary> 
# Usage : langstat.sh --percentage <dictionary>
# Usage : langstat.sh --word <word> <dictionary>
# Usage : langstat.sh --all <dictionary>

if [[ $# -ne 1 && $# -ne 2 ]]
then
	echo "Usage : $0 <dictionary>"
	exit
fi

if [ ! -e $1 ]
then
	echo "Error : $1 does not exist"
	exit
fi

if [ ! -f $1 ]
then
	echo "Error : $1 is not a regular file"
	exit
fi

if [ ! -r $1 ]
then 
	echo "Error : $1 is not readable"
	exit
fi

while [[ -z $filename || -f $filename ]] 
do
	filename="$RANDOM.tmp"
done

alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
size=`expr length $alphabet`
index=1

while [ $index -le $size ]
do
	letter=`expr substr $alphabet $index 1`
	echo "`grep -c $letter $1` - $letter" >> $filename
	index=$((index+1))
done

sort -rn $filename

rm $filename

