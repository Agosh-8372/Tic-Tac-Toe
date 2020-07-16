NUM_ROWS=3
NUM=COLS=3

userLetterTemp=0
chance=""
player=0
flag=0
computer=0
gameStop=0
countX=0
countO=0

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
		((countX++))
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
		((countO++))
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
	else
		compLetter=X
	fi
	if [[ $chance == computer &&  $compLetter == X ]]
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
   	((countO++))
   	computer
	elif [[ $chance == computer ]]
	then
   	((countX++))
   	user
	else
   	echo "Error"
	fi
}

function checkChance()
{
	for (( countV=0; countV<${#playBoard[@]};countV++ ))
	do
		if [[ ${playBoard[countV]} == "-" ]]
		then
			chanceSwitch
			break;
		fi
	done
}

function checkDraw()
{
	if [[ $countX -eq 5 && $countO -eq 4 ]] || [[ $countX -eq 4 && $countO -eq 5 ]]
	then
		echo "its a draw"
		gameStop=1;
	elif [[ $countX -eq 4 && $countO -eq 5 ]]
	then
		echo "its a draw"
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
	c=$1
	if [[ ${playBoard[$((c))]} == "-" ]]
	then
   	playBoard[$((c))]=$compLetter
	else
   	compInputValue
	fi
}

function compInputValue()
{
	cval=$((RANDOM%9))
	computerMove $cval
}


function checkWinPos()
{
	if [[ ${playBoard[$1]} == "-" && ${playBoard[$2]} == $compLetter && ${playBoard[$3]} == $compLetter ]]
	then
		playBoard[$1]=$compLetter
		flag=1
	elif [[ ${playBoard[$2]} == "-" && ${playBoard[$1]} == $compLetter && ${playBoard[$3]} == $compLetter ]]
	then
		playBoard[$2]=$compLetter
		flag=1
	elif [[ ${playBoard[$3]} == "-" && ${playBoard[$1]} == $compLetter && ${playBoard[$2]} == $compLetter ]]
	then
		playBoard[$3]=$compLetter
		flag=1
   fi
}


function computerPlay(){
	checkWinPos 0 1 2
	checkWinPos 3 4 5
	checkWinPos 6 7 8
	checkWinPos 0 3 6
	checkWinPos 1 4 7
	checkWinPos 2 5 8
	checkWinPos 0 4 8
	checkWinPos 2 4 6
	if [ $flag -eq 0 ]
	then
		compInputValue
	fi
}

function yourMove()
{
	pos=$1
	if [[ ${playBoard[$((pos-1))]} == "-" ]]
	then
		playBoard[$((pos-1))]=$userLetter
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
