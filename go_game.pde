public int boardSize = 13;  // Number of rows/columns on the board
public int boardX = 200;  // X position of the board (top-left corner)
public int boardY = 100;  // Y position of the board (top-left corner)
public color boardColor = #DCB35C;
public int boxSize = 50;  // Number of pixels between each line on the board
public int screenWidth = boardSize * boxSize + 350;
public int screenHeight = boardSize * boxSize + 100;
public int bgColor = 180;
public int stoneSize = (int)(0.8 * boxSize);  // Diameter of each stone
public int boardLength = boxSize * (boardSize - 1);
public int[][] board = new int[boardSize][boardSize];  // 0 - Empty, 1 - Black, 2 - White
public static final int EMPTY = 0;
public static final int BLACK = 1;
public static final int WHITE = 2;
public int currentPlayer = BLACK;  // Black player goes first
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
public int blackScore = 0;  // Holds current score
public int whiteScore = 0;
public boolean passedTurn = false;  // true if last turn was passed
public boolean gameOver = false;
public int gameOverX = boardX;
public int gameOverY = boardY - 5;


void setup(){
	// Initializes the board state
	size(screenWidth, screenHeight);
	clearBoard();
	drawBoard();
	//TODO - remove this before handing in
	test();
}

void test(){
	testGroupFunctions();
}

void draw() {
	// draw background to clear screen
	background(bgColor);
	drawBoard();
	drawStones();
	drawScoreboard();
	if (gameOver) {
		drawGameOver();
	}
	else {
		drawPlayerTurn();
		drawPassBtn();
	}
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
	// draws the group currently on the board
	for (int i = 0; i < boardSize; i++){
		for (int j = 0; j < boardSize; j++){
			if (board[i][j] == BLACK) {	
				drawStone(i, j, BLACK);
			}
			else if (board[i][j] == WHITE) {
				drawStone(i, j, WHITE);	
			}
		}
	}
}

void drawStone(int xPos, int yPos, int player){
	// draws a stone at xPos, yPos for player
	if (player == BLACK) {
		fill(0);
	}
	else {
		fill(255);
	}
	ellipse(boardX + xPos * boxSize, boardY + yPos * boxSize, stoneSize, stoneSize);
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
	textSize(20);
	fill(0);
	textAlign(LEFT);
	text("Score:", scoreX, scoreY);
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
	text("GAME OVER", boardX + boardLength / 2, boardY - 60);
	if (blackScore > whiteScore) {
		winner = "Black player wins!!";
	}
	else if (whiteScore > blackScore) {
		winner = "White player wins!!";
	}
	else {
		winner = "It's a tie!!";	
	}
	text(winner, boardX + boardLength / 2, boardY - 5);
}

void mouseClicked(){
	// handles mouse click events
	int xBoardPos = getXPos(mouseX);
	int yBoardPos = getYPos(mouseY);
	if (clickedOnBoard(xBoardPos, yBoardPos)) {
		if (stonePlayAllowed(xBoardPos, yBoardPos)) {
			board[xBoardPos][yBoardPos] = currentPlayer;
			passedTurn = false;
			// check for captures
			changePlayer();
		}
	}
	else if (clickedPass(mouseX, mouseY)) {
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
}

boolean clickedPass(int clickX, int clickY) {
	return (clickX >= passBtnX) && (clickX <= passBtnX + passBtnWidth)
			&& (clickY >= passBtnY) && (clickY <= passBtnY + passBtnHeight);
}

boolean clickedOnBoard(int xPos, int yPos) {
	// returns true if xPos, yPos is a valid position on the board
	return (xPos >= 0) && (xPos <= (boardSize - 1)) && (yPos >= 0) && (yPos <= (boardSize - 1));	
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

///////////////GROUP FUNCTIONS/////////////////////
//depends on boardSize, board

public void testGroupFunctions(){
	boardSize = 5;
	board = new int[boardSize][boardSize];
	clearBoard();
	
	//connected group
	board[1][2] = BLACK;
	board[1][3] = BLACK;
	board[2][2] = BLACK;

	//disconnected piece
	board[4][4] = BLACK;
	
	getGroup(1,2);
	System.out.println("group found:");
	for (int i = 0; i<groupSize; i++){
		System.out.println(group[i][0] + ", " + group[i][1] );
	}

	if(isGroupAlive()){
		System.out.println("group is alive");	
	}
	else{
		System.out.println("group is dead");		
	}

	//surrounded piece
	board[4][0] = BLACK;
	board[3][0] = WHITE;
	board[4][1] = WHITE;

	getGroup(4,0);
	System.out.println("group found:");
	for (int i = 0; i<groupSize; i++){
		System.out.println(group[i][0] + ", " + group[i][1] );
	}

	if(isGroupAlive()){
		System.out.println("group is alive");	
	}
	else{
		System.out.println("group is dead");		
	}
}


int [][] group;
int groupSize;
int xMin, xMax, yMin, yMax;
int groupColor;

//TODO - make a function that checks if the group stored in "group" is alive

public void getGroup(int xPos, int yPos){
	groupSize = 0;
	group = new int [boardSize*boardSize][2];
	xMin = 0;
	xMax = boardSize-1;
	yMin = 0;
	yMax = boardSize-1;
	groupColor = board[xPos][yPos];
	findGroupRecursively(xPos, yPos);
}

public void findGroupRecursively(int xPos, int yPos){
	//System.out.println("DEBUG begin findGroupRecursively" + xPos + ", " + yPos);
	
	boolean checksPass = true;

	//check if stone is in range
	if(xPos < xMin || xMax < xPos || yPos < yMin || yMax < yPos){
		checksPass = false;
	}

	//check if stone at this location is proper color
	else if(groupColor != board[xPos][yPos]){
		checksPass = false;
	}
	//System.out.println("DEBUG checks" + groupColor + ", " + board[xPos][yPos]);


	
	//check that location is not already in list
	for(int i = 0; i<groupSize; i++){
		if (xPos == group[i][0] && yPos == group[i][1]){
			checksPass = false;
		}
	}
		
	if(checksPass){
		//add location to list and run function on each neighboring location
		group[groupSize][0] = xPos;
		group[groupSize][1] = yPos;
		groupSize++;
		findGroupRecursively(xPos+1, yPos);
		findGroupRecursively(xPos-1, yPos);
		findGroupRecursively(xPos, yPos+1);
		findGroupRecursively(xPos, yPos-1);
		
	}
	
}
//look at existing group, saved in class variables, determine if it is alive
public boolean isGroupAlive(){
	boolean hasLiberty = false;
	for(int i = 0; i<groupSize; i++){
		int x = group[i][0];
		int y = group[i][1];
		//TODO - pull this out into a function that gets surrounding stones
		if(y+1 < yMax && board[x][y+1] == EMPTY){
			hasLiberty = true;
		}
		if(y-1 > yMin && board[x][y-1] == EMPTY){
			hasLiberty = true;
		}
		if(x+1 < xMax && board[x+1][y] == EMPTY){
			hasLiberty = true;
		}
		if(x-1 > xMax && board[x-1][y] == EMPTY){
			hasLiberty = true;
		}
	}	
	return hasLiberty;
}

//public void removeGroup(){}

///////////END GROUP FUNCTIONS//////////////////////

//TODO - get surrounding spaces function