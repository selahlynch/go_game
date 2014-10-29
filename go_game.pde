int boardSize = 13;  // Number of rows/columns on the board
public int boardX = 200;  // X position of the board (top-left corner)
public int boardY = 100;  // Y position of the board (top-left corner)
public color boardColor = #DCB35C;
public int boxSize = 50;  // Number of pixels between each line on the board
public int screenWidth = boardSize * boxSize + 350;
public int screenHeight = boardSize * boxSize + 100;
public int bgColor = 180;
public int stoneSize = (int)(0.8 * boxSize);  // Diameter of each stone
public double stoneFadeTime = 500;  // Fade time for captured stones (milliseconds)
public int savedTime = millis();
public int[][] capturedStones = new int[0][0];
public int boardLength = boxSize * (boardSize - 1);
public int[][] board = new int[boardSize][boardSize];  // 0 - Empty, 1 - Black, 2 - White
public static final int EMPTY = 0;
public static final int BLACK = 1;
public static final int WHITE = 2;
public int currentPlayer;
public int playerTextX = boardX + (int) (boardLength * 0.5) - 75;  // Position of player text
public int playerTextY = boardY - 35;
public int passBtnX = playerTextX - 120;  // Position of pass button
public int passBtnY = playerTextY - 30;
public int passBtnWidth = 100;  // Size of pass button
public int passBtnHeight = 40;
public int scoreX = 20;  // Position of score text
public int scoreY = 120;
public int blackScoreX = 20;
public int blackScoreY = 150;
public int whiteScoreX = 20;
public int whiteScoreY = 180;
public int blackScore;  // Holds current score
public int whiteScore;
public boolean passedTurn;  // true if last turn was passed
public boolean gameOver;
public int winnerX = (boardX + boardLength / 2);
public int winnerY = boardY - 50;
public int playAgainX = winnerX + 120;
public int playAgainY = winnerY - 40;
public int playAgainWidth = 180;
public int playAgainHeight = 50;


void setup(){
	// Initializes the board state
	size(screenWidth, screenHeight);
	clearBoard();
	initGame();
	drawBoard();
	
	//TODO - remove this before handing in
	//testInitGroup();
	testCaptureStones();
}

void draw() {
	// draw background to clear screen
	background(bgColor);
	drawBoard();
	drawStones();
	drawFadingStones();
	drawScoreboard();
	if (gameOver) {
		drawGameOver();
	}
	else {
		drawPlayerTurn();
		drawPassBtn();
	}
}

void initGame(){
	whiteScore = 0;
	blackScore = 0;
	passedTurn = false;
	gameOver = false;
	currentPlayer = BLACK;
}

void clearBoard(){
	// clears out the board[][] array
	for (int i = 0; i < boardSize; i++){
		for (int j = 0; j < boardSize; j++){
			board[i][j] = EMPTY;
		}
	}	
}

void drawBoard() {
	// draws the bare board
	fill(boardColor);
	strokeWeight(2);
	rect(boardX, boardY, boardLength, boardLength);
	strokeWeight(1);
	for (int i = 0; i < boardSize; i++){
		line(boardX + i * boxSize, boardY, boardX + i * boxSize, boardY + boardLength);
		line(boardX, boardY + i * boxSize, boardX + boardLength, boardY + i * boxSize);
	}	
}

void drawStones() {
	// draws the stones currently on the board
	for (int i = 0; i < boardSize; i++){
		for (int j = 0; j < boardSize; j++){
			if (board[i][j] == BLACK) {	
				drawStone(i, j, BLACK, 255);
			}
			else if (board[i][j] == WHITE) {
				drawStone(i, j, WHITE, 255);	
			}
		}
	}
}

void drawFadingStones() {
	int fade = (int) (255 * (1.0 - (millis() - savedTime) / stoneFadeTime));
	if (fade <= 0) {
		capturedStones = new int[0][0];
	}
	int stoneX, stoneY, player;
	for (int i = 0; i < capturedStones.length; i++) {
		stoneX = capturedStones[i][0];
		stoneY = capturedStones[i][1];
		player = capturedStones[i][2];
		drawStone(stoneX, stoneY, player, fade);
	}
}

void drawStone(int xPos, int yPos, int player, int fadeAlpha){
	// draws a stone at xPos, yPos for player
	noStroke();
	if (player == BLACK) {
		fill(0, fadeAlpha);
	}
	else {
		fill(255, fadeAlpha);
	}
	ellipse(boardX + xPos * boxSize, boardY + yPos * boxSize, stoneSize, stoneSize);
	stroke(0);
}


void drawPlayerTurn() {
	// draws the text to display the current player
	String player;
	fill(0);
	textSize(20);
	textAlign(LEFT);
	if (currentPlayer == BLACK){
		player = "Black";	
	}
	else {
		player = "White";	
	}
	text(player + " player's turn", playerTextX, playerTextY);	
}

void drawScoreboard() {
	// draws the scoreboard
	textSize(22);
	fill(0);
	textAlign(LEFT);
	text("Score", scoreX, scoreY);
	textSize(20);
	text("Black: " + blackScore, blackScoreX, blackScoreY);
	fill(255);
	text("White: " + whiteScore, whiteScoreX, whiteScoreY);
}

void drawPassBtn() {
	// draws the pass button
	fill(64, 224, 208);
	rect(passBtnX, passBtnY, passBtnWidth, passBtnHeight);
	fill(0);
	textSize(24);
	textAlign(LEFT);
	text("PASS", passBtnX + 20, passBtnY + 30);	
}

void drawGameOver() {
	// draws the game over display
	String winner;
	fill(0);
	textSize(50);
	textAlign(CENTER);
	if (blackScore > whiteScore) {
		winner = "Black player wins!!";
	}
	else if (whiteScore > blackScore) {
		winner = "White player wins!!";
	}
	else {
		winner = "It's a tie!!";	
	}
	text(winner, winnerX, winnerY);
	fill(64, 224, 208);
	rect(playAgainX, playAgainY, playAgainWidth, playAgainHeight);
	fill(0);
	textSize(24);
	textAlign(LEFT);
	text("Play again", playAgainX + 20, playAgainY + 30);
}

void mouseClicked(){
	// handles mouse click events
	if (capturedStones.length == 0) {
		int xBoardPos = getXPos(mouseX);
		int yBoardPos = getYPos(mouseY);
		if (clickedOnBoard(xBoardPos, yBoardPos) && !gameOver) {
			if (stonePlayAllowed(xBoardPos, yBoardPos)) {
				board[xBoardPos][yBoardPos] = currentPlayer;
				passedTurn = false;
				// check for captures
				changePlayer();
			}
		}
		else if (clickedPass(mouseX, mouseY) && !gameOver) {
			if (passedTurn) {
				// Game Over
				gameOver = true;
				// Find winner
			}
			else {
				passedTurn = true;
				changePlayer();
			}
		}
		else if (clickedPlayAgain(mouseX, mouseY) && gameOver) {
			setup();
		}
	}
}

boolean clickedPass(int clickX, int clickY) {
	// returns true if the coordinates given are inside the pass button
	return (clickX >= passBtnX) && (clickX <= passBtnX + passBtnWidth)
			&& (clickY >= passBtnY) && (clickY <= passBtnY + passBtnHeight);
}

boolean clickedOnBoard(int xPos, int yPos) {
	// returns true if xPos, yPos is a valid position on the board
	return (xPos >= 0) && (xPos <= (boardSize - 1)) && (yPos >= 0) && (yPos <= (boardSize - 1));	
}

boolean clickedPlayAgain(int clickX, int clickY) {
	// returns true if the coordinates given are inside the play again button
	return (clickX >= playAgainX) && (clickX <= (playAgainX + playAgainWidth))
			&& (clickY >= playAgainY) && (clickY <= (playAgainY + playAgainHeight));	
}

int getXPos(int clickX) {
	// gets the x-position on the board from the X pixel coordinate
	return (int) Math.round((clickX - boardX) / (float)(boxSize));
}

int getYPos(int clickY) {
	// gets the y-position on the board from the Y pixel coordinate
	return (int) Math.round((clickY - boardY) / (float)(boxSize));
}

boolean stonePlayAllowed(int xPos, int yPos) {
	// checks whether the player is allowed to place a stone
	return isEmpty(xPos, yPos);
}

boolean isEmpty(int xPos, int yPos) {
	// returns true if the position is empty
	return board[xPos][yPos] == EMPTY;	
}

void changePlayer() {
	// changes the current player
	if (currentPlayer == 1) {
		currentPlayer = 2;	
	}
	else {
		currentPlayer = 1;
	}
}

void captureStones() {
	int numStones = group.length;
	int player = groupColor;
	int stoneX, stoneY;
	capturedStones = new int[numStones][3];
	for (int i = 0; i < numStones; i++){
		stoneX = group[i][0];
		stoneY = group[i][1];
		removeStone(stoneX, stoneY);
		capturedStones[i][0] = stoneX;
		capturedStones[i][1] = stoneY;
		if (player == BLACK) {
			whiteScore++;
		}
		else {
			blackScore++;
		}
		capturedStones[i][2] = player;
	}
	savedTime = millis();
}

void removeStone(int xPos, int yPos){
	board[xPos][yPos] = EMPTY;	
}

void testCaptureStones() {
	group = new int[5][3];
	group[0][0] = 9;
	group[0][1] = 2;
	group[0][2] = 1;
	group[1][0] = 2;
	group[1][1] = 3;
	group[1][2] = 1;
	group[2][0] = 3;
	group[2][1] = 2;
	group[2][2] = 1;
	group[3][0] = 3;
	group[3][1] = 3;
	group[3][2] = 1;
	group[4][0] = 5;
	group[4][1] = 5;
	group[4][2] = 2;
	captureStones();
}
///////////////GROUP FINDING FUNCTIONS/////////////////////
////////TODO - move this to separate Group class////////
//depends on boardSize, board

public void testInitGroup(){
	boardSize = 5;
	board = new int[boardSize][boardSize];
	clearBoard();
	board[1][2] = BLACK;
	board[1][3] = BLACK;
	board[2][2] = BLACK;
	board[4][4] = BLACK;
	initGroup(1,2,BLACK);
	System.out.println("stones found:");
	for (int i = 0; i<listPos; i++){
		System.out.println(stones[i][0] + ", " + stones[i][1] );
	}
}


int [][] stones;
int listPos;
int xMin, xMax, yMin, yMax;
int who;

//TODO - make a function that checks if the group stored in "stones" is alive

public void initGroup(int xPos, int yPos, int whoInit){
	listPos = 0;
	stones = new int [boardSize*boardSize][2];
	xMin = 0;
	xMax = boardSize-1;
	yMin = 0;
	yMax = boardSize-1;
	who = whoInit;
	findGroupRecursively(xPos, yPos);
}

public void findGroupRecursively(int xPos, int yPos){
	//System.out.println("DEBUG begin findGroupRecursively" + xPos + ", " + yPos);
	
	boolean checksPass = true;

	//check if stone at this location is proper color
	if(who != board[xPos][yPos]){
		checksPass = false;
	}
	//System.out.println("DEBUG checks" + who + ", " + board[xPos][yPos]);


	//check if stone is in range
	if(xPos < xMin || xMax < xPos || yPos < yMin || yMax < yPos){
		checksPass = false;
	}
	
	//check that location is not already in list
	for(int i = 0; i<listPos; i++){
		if (xPos == stones[i][0] && yPos == stones[i][1]){
			checksPass = false;
		}
	}
		
	if(checksPass){
		//add location to list and run function on each neighboring location
		stones[listPos][0] = xPos;
		stones[listPos][1] = yPos;
		listPos++;
		findGroupRecursively(xPos+1, yPos);
		findGroupRecursively(xPos-1, yPos);
		findGroupRecursively(xPos, yPos+1);
		findGroupRecursively(xPos, yPos-1);
		
	}

}
///////////END GROUP FINDING FUNCTIONS//////////////////////

