NUM_ROWS=3
NUM_COLS=3
BOARD_SIZE=$((NUM_ROWS * NUM_COLS))

userLetterTemp=0
chance=""
player=0
flag=0
computer=0
gameStop=0

declare -a playBoard

function resetPlayBoard()
{
	playBoard=(- - - - - - - - -)
}


function toss()
{
	random=$((RANDOM%2))
	if [[ $random -eq 0 ]]
	then
		chance="player";
		read -p "Players chance first,choose your letter X or O " input
		if [[ $input == X ]]
		then
			userLetter=X;
		else
			userLetter=O;
		fi
	else
		echo "Computers chance first"
		chance="computer";
		choose=$((RANDOM%2))
		if [ $choose -eq 0 ]
		then
			compLetter=O;
		else
			compLetter=X;
		fi
	fi
}

function symbolAssign()
{
	if [[ $chance == player &&  $userLetter == X ]]
	then
		compLetter=O
	elif [[ $chance == player && $userLetter == O ]]
	then
		compLetter=X
	elif [[ $chance == computer &&  $compLetter == X ]]
	then
		userLetter=O
	else
		userLetter=X
	fi
}

function displayBoard()
{
	echo "Game Board At Display"
	for (( count=0;count<${#playBoard[@]};))
	do
		echo "|${playBoard[count]}|${playBoard[count+1]}|${playBoard[count+2]}|"
		count=$((count+3))
	done
}

function user()
{
	chance="player"
	userLetterTemp=$userLetter
}

function computer()
{
	chance="computer"
	userLetterTemp=$compLetter
}

function chanceSwitch()
{
	if [[ $chance == player ]]
	then
		computer
	elif [[ $chance == computer ]]
	then
		user
	fi
}

function checkChance()
{
	for (( count=0; count<${#playBoard[@]};count++ ))
	do
		if [[ ${playBoard[count]} == "-" ]]
		then
			chanceSwitch
			break;
		fi
	done
}

function checkDraw()
{
	total=0;
	for ((pos=0;pos<$BOARD_SIZE;pos++))
	do
		if [[ ${playBoard[pos]} != "-" ]]
		then
			((++total))
		fi
	done
		if [[ $total -eq $BOARD_SIZE ]]
		then
			echo "Match is draw"
			gameStop=1;
		fi
}

function checkWin()
{
	if [[ ${playBoard[$1]} != "-" ]] && [[ ${playBoard[$1]} == ${playBoard[$2]} ]] && [[ ${playBoard[$2]} == ${playBoard[$3]} ]]
	then
		gameStop=1
		echo "$chance Wins"
	fi
}

function checkWinLoose()
{
	checkWin 0 1 2
	checkWin 3 4 5
	checkWin 6 7 8
	checkWin 0 3 6
	checkWin 1 4 7
	checkWin 2 5 8
	checkWin 0 4 8
	checkWin 2 4 6
}

function computerMove()
{
	place=$1
	if [[ ${playBoard[$place]} == "-" ]]
	then
		playBoard[$place]=$compLetter
	else
		compInputValueSides
	fi
	return;
}

function compInputValueSides()
{
	if [ $flag -eq 0 ]
	then
		compPos=$((RANDOM%9))
		computerMove $compPos
	else
		flag=0
	fi
}


function checkWinPos()
{
	if [[ ${playBoard[$1]} == "-" && ${playBoard[$2]} == $compLetter && ${playBoard[$3]} == $compLetter  && $flag == 0  ]]
	then
		playBoard[$1]=$compLetter
		flag=1
	elif [[ ${playBoard[$2]} == "-" && ${playBoard[$1]} == $compLetter && ${playBoard[$3]} == $compLetter  && $flag == 0 ]]
	then
		playBoard[$2]=$compLetter
		flag=1
	elif [[ ${playBoard[$3]} == "-" && ${playBoard[$1]} == $compLetter && ${playBoard[$2]} == $compLetter  && $flag == 0 ]]
	then
		playBoard[$3]=$compLetter
		flag=1
	elif [[ ${playBoard[$1]} == "-" && ${playBoard[$2]} == $userLetter && ${playBoard[$3]} == $userLetter && $flag == 0 ]]
	then
		playBoard[$1]=$compLetter
		flag=1
	elif [[ ${playBoard[$2]} == "-" && ${playBoard[$1]} == $userLetter && ${playBoard[$3]} == $userLetter && $flag == 0 ]]
	then
		playBoard[$2]=$compLetter
		flag=1
	elif [[ ${playBoard[$3]} == "-" && ${playBoard[$1]} == $userLetter && ${playBoard[$2]} == $userLetter && $flag == 0 ]]
	then
		playBoard[$3]=$compLetter
		flag=1
	fi
	return;
}

function checkCornersCentre()
{
	if [[ ${playBoard[0]} == "-" && $flag == 0 ]]
	then
		playBoard[0]=$compLetter
		flag=1
	elif [[ ${playBoard[2]} == "-"  && $flag == 0 ]]
	then
		playBoard[2]=$compLetter
		flag=1
	elif [[ ${playBoard[6]} == "-"  && $flag == 0 ]]
	then
		playBoard[6]=$compLetter
		flag=1
	elif [[ ${playBoard[8]} ==  "-"  && $flag == 0 ]]
	then
		playBoard[8]=$compLetter
		flag=1
	elif [[ ${playBoard[4]} ==  "-" &&  $flag == 0 ]]
	then
		playBoard[4]=$compLetter
		flag=1
	fi
	return;
}

function computerPlay()
{
	checkWinPos 0 1 2
	checkWinPos 3 4 5
	checkWinPos 6 7 8
	checkWinPos 0 3 6
	checkWinPos 1 4 7
	checkWinPos 2 5 8
	checkWinPos 0 4 8
	checkWinPos 2 4 6
}

function yourMove()
{
	position=$1
	if [[ ${playBoard[$((position-1))]} == "-" ]]
	then
		playBoard[$((position-1))]=$userLetter
	else
		userInputPosition
	fi
}

function userInputPosition()
{
	echo "players chance Please enter a position to insert"
	read user_input
	yourMove $user_input
}

function gamePlay()
{
	case $chance in
	player)
		userInputPosition
		displayBoard
		checkWinLoose
		checkDraw
		checkChance
			;;
	computer)
		computerPlay
		checkCornersCentre
		compInputValueSides
		displayBoard
		checkWinLoose
		checkDraw
		checkChance
			;;
	esac
}
resetPlayBoard
toss
symbolAssign
displayBoard
while (( $gameStop == 0 ))
do
	gamePlay
done
