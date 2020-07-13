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
resetPlayBoard
