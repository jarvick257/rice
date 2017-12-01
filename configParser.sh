#!/bin/zsh

if [[ $# -ne 2 ]]; then
	echo "usage: $0 <Src-Path> <Dst-Path>"
	return
fi

if [[ $HOST == "jarvick_desktop" ]]; then
	FIL='D'
else
	FIL='L'
fi
SRC=$1
DST=$2

if [[ ! -f $SRC ]]; then
	echo "Error: Source file does not exist!"
	return
fi

if [[ -f $DST ]]; then
	rm $DST
fi

MLTS="->>"
MLTE="<<-"
SLT="-->"

in_mlt=0
own_mlt=0
IFS=""
while read -r line
do
	for F in ${(@s/,/)FIL}; do
		O_MLTS="$F$MLTS"
		O_SLT="$F$SLT"


		# Single Line
		if [[ $line == *$O_SLT* ]]; then
			printf "%s\n" $line | awk -F $O_SLT '{print $1 $2}' >> $DST
		# Multiline Tag Start
		elif [[ $line == *$MLTS* ]]; then
			in_mlt=1
			if [[ $line == *$O_MLTS* ]]; then
				own_mlt=1
			fi
		# Multiline Tag End
		elif [[ $line == *$MLTE* ]]; then
			in_mlt=0
			own_mlt=0
		fi
	done
	# Empty Line
	if [[ ! $line == *$SLT* && ! $line == *$MLTS* && ! $line == *$MLTE* ]]; then 
		# In Own Mutliline Tag
		if (( $own_mlt == 1 || $in_mlt == 0 )); then
			printf "%s\n" $line >> $DST
		fi
	fi
done < "$SRC"
