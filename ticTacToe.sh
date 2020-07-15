NUM_ROWS=3
NUM=COLS=3

userLetterTemp=0
chance=""
player=0
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
		userLetterTemp=X;
	else
		userLetterTemp=O;
	fi
else
	echo "Computers chance first"
	chance="computer";
	((countO++))
	choose=$((RANDOM%2))
	if [ $choose -eq 0 ]
	then
		userLetterTemp=O;
	else
		userLetterTemp=X;
	fi
fi
}

function symbolAssign()
{
if [[ $chance == player &&  $userLetterTemp == X ]]
then
	userLetter=X
	compLetter=O
elif [[ $chance == player &&  $userLetterTemp == O ]]
then
	userLetter=O
	compLetter=X
elif [[ $chance == computer &&  $userLetterTemp == X ]]
then
	compLetter=X
	userLetter=O
else
	compLetter=O
	userLetter=X
fi
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
gamePlay
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

function displayBoard()
{
echo "Game Board At Display"
for (( count=0;count<${#playBoard[@]};))
do
	echo "|${playBoard[count]}|${playBoard[count+1]}|${playBoard[count+2]}|"
	count=$((count+3))
done
}

function checkChance()
{
for (( countV=0; countV<${#playBoard[@]};countV++ ))
do
	if [[ ${playBoard[countV]} == - ]]
	then
		chanceSwitch
		break;
	fi
done
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

function yourMove()
{
echo "$chance turn,please enter a position to insert"
read r
if [[ ${playBoard[$((r-1))]} == "-" ]]
then
	playBoard[$((r-1))]=$userLetterTemp
else
	echo "position Invalid enter values again"
	yourMove
fi
}

function gamePlay()
{
while (( $gameStop == 0 ))
do
	case $chance in
	player)
		yourMove
		displayBoard
		checkWinLoose
		checkDraw
		checkChance
			;;
	computer)
		yourMove
		displayBoard
		checkWinLoose
		checkDraw
		checkChance
			;;
	esac
done
}
resetPlayBoard
toss
symbolAssign
displayBoard
gamePlay
