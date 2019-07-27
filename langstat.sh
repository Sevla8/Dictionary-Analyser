#!/bin/bash

# langstat.sh : give statistics on letter occurrences in a specific language
# Usage : langstat.sh <dictionary>
# -> Display the number of times each letter is used at least once in a word of <dictionary>
# Usage : langstat.sh -p <dictionary>
# -> Display the percentage of times each letter is used at least once in a word of <dictionary>
# Usage : langstat.sh -w <word> <dictionary>
# -> Return true if <word> is a word of <dictionary>
# Usage : langstat.sh -a <dictionary>
# -> Display the number of times each letter is used in <dictionary>
# Usage : langstat.sh -b <alphabet> <dictionary>
# -> Display the number of times each letter is used at least once in a word of <dictionary> using <alphabet> as alphabet

dico=${!#}

# Usage
usage() {
	echo "Usage: $0 ([-p] [-a] [--b <alphabet>]) | ([-w <word>]) <dictionary>"
}

# Word
word() {
	count=`grep -iwc $word $dico` 
	if [ $count -ge 1 ]
	then
		echo true
	else 
		echo false
	fi
}

# Main
main() {
	while [[ -z $filename || -f $filename ]]
	do
		filename="$RANDOM.tmp"
	done

	if [ -z $alphabet ]
	then
		alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	fi

	size=`expr length $alphabet`
	index=1

	while [ $index -le $size ]
	do
		letter=`expr substr $alphabet $index 1`
		if [[ -n $percentage && $percentage = true ]]
		then
			echo "$((`wc -l $dico | cut -d ' ' -f 1` / `grep -ic $letter $dico`)) - $letter" >> $filename
		else
			echo "`grep -ic $letter $dico` - $letter" >> $filename
		fi
		index=$((index++))
	done

	sort -rn $filename
	
	rm $filename
}


# Tests to check if all is ok
if [[ $# -lt 1 || $# -gt 5 ]]
then
	usage
fi
if [ ! -e $dico ]
then
	echo "Error: $dico does not exist"
	exit
fi
if [ ! -f $dico ]
	then
	echo "Error:  $dico is not a regular file"
	exit
fi
if [ ! -r $dico ]
then 
	echo "Error: $dico is not readable"
	exit
fi

# Option management
while getopts ":pab:w:" option
do
	case "${option}" in 
		p)
			percentage=true
			main
			exit 0
			;;
		a)
			all=true
			main
			exit 0
			;;
		b)
			alphabet=${OPTARG}
			main
			exit 0
			;;
		w)
			word=${OPTARG}
			word
			exit 0
			;;
		*)
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND--))

# Without options
main
exit 0

