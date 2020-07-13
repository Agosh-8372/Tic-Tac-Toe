#!/bin/bash -x
NUM_ROWS=3
NUM=COLS=3
BOARD_SIZE=$((NUM_ROWS*NUM_COLS))

position=0
declare -a playBoard

function resetPlayBoard()
{
	for((position=1;position<=BOARD_SIZE;position++))
	do
		playBoard[$position]=0;
	done
}


function toss()
{
	random=$((RANDOM%2))
		if [ $random -eq 0 ]
		then
			read -p "Players chance first,choose your letter X or O" input
				if [[ $input == X ]]
				then
					userLetter=X;
					compLetter=O;
				else
					userLetter=O;
					compLetter=X;
				fi
		else
			echo "Computers chance first"
			choose=$((RANDOM%2))
				if [ $choose -eq 0 ]
				then
					userLetter=O;
					compLetter=X;
				else
					userLetter=X;
					compLetter=O;
				fi

		fi
}
toss
