import java.util.Arrays;

public int boardSize = 13;  // Number of rows/columns on the board
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
public int playAgainX = winnerX + 250;
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
	//test();
}

void test(){
	testCaptureStones();
	testGroupFunctions();
	testGetSurroundingLocations();
	testIsValidLocation();
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
	// initializes variables to start a new game
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
	// draws stones that have been captured using a fading effect
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
		if (onBoard(xBoardPos, yBoardPos) && !gameOver) {
			if (stonePlayAllowed(xBoardPos, yBoardPos)) {
				board[xBoardPos][yBoardPos] = currentPlayer;
				passedTurn = false;
				checkForCaptures(xBoardPos, yBoardPos);
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

boolean onBoard(int xPos, int yPos) {
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

void checkForCaptures(int xPos, int yPos) {
	// checks for captured groups after piece is placed at indicated location
	int[] xList = {xPos, xPos + 1, xPos, xPos - 1, xPos};
	int[] yList = {yPos - 1, yPos, yPos + 1, yPos, yPos};
	int xNext, yNext;
	for (int i = 0; i < 5; i++){
		xNext = xList[i];
		yNext = yList[i];
		if (onBoard(xNext, yNext)) {
			int[][] g = getGroup(xNext, yNext);
			if (!isGroupAlive(g)){
				captureStones();	
			}
		}
	}
}

void captureStones() {
	// Removes captured stones from the board and scores them appropriately
	int numStones = groupSize;
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
	// Empties the indicated board position
	board[xPos][yPos] = EMPTY;	
}

void testCaptureStones() {
	group = new int[5][2];
	group[0][0] = 9;
	group[0][1] = 2;
	group[1][0] = 2;
	group[1][1] = 3;
	group[2][0] = 3;
	group[2][1] = 2;
	group[3][0] = 3;
	group[3][1] = 3;
	group[4][0] = 5;
	group[4][1] = 5;
	captureStones();
}


public void assertTrue(boolean b, String msg){
	if(!b){
		throw new Error(msg);		
	}
}

public void testIsValidLocation(){
	assertTrue(isValidLocation(new int[]{2,2}), "(2,2) is a valid location");
	assertTrue(!isValidLocation(new int[]{-1,5}), "(-1,5) is not a valid location");
}

public boolean isValidLocation(int[] loc){
	int x = loc[0];
	int y = loc[1];
	int xMin = 0;
	int xMax = boardSize-1;
	int yMin = 0;
	int yMax = boardSize-1;	
	return xMin <= x && x <= xMax && yMin <= y && y<= yMax;
}

//convert one location to a string
public String locString(int[] loc){
	String s = "(" + loc[0] + ", " + loc[1] + ")";
	return s;
}

//convert a series of locations to a string
public String locArrayString(int[][] locs){
	String s = "" + locString(locs[0]);
	for(int i=1; i<locs.length; i++){
		s = s + ", " + locString(locs[i]);
	}
	return s;
}

public void testGetSurroundingLocations(){	
	int[][] surroundingLocations = getSurroundingLocations(3,4);
	assertTrue(locArrayString(surroundingLocations).equals("(4, 4), (3, 3), (2, 4)"), "surrounding locations mismatch");	
}

public int[][] getSurroundingLocations(int x, int y){
	int[][] locs = new int[4][2];

	int locCount = 0;
	if(y+1<=yMax){
		locs[locCount][0] = x;
		locs[locCount][1] = y+1;
		locCount++;
	}
	if(x+1<=xMax){
		locs[locCount][0] = x+1;
		locs[locCount][1] = y;
		locCount++;
	}
	if(y-1>=xMin){
		locs[locCount][0] = x;
		locs[locCount][1] = y-1;
		locCount++;
	}
	if(x-1>=xMin){
		locs[locCount][0] = x-1;
		locs[locCount][1] = y;
		locCount++;
	}

	int[][] retVal = new int[locCount][2];
	for(int i = 0; i<locCount; i++){
		retVal[i] = locs[i];
	}
	return retVal;
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
	
	int[][] g1 = getGroup(1,2);
	assertTrue(locArrayString(g1).equals("(1, 2), (1, 3), (2, 2)"),"group 1 is wrong");
	assertTrue(isGroupAlive(g1),"group 1 should be alive");

	//surrounded piece
	board[4][0] = BLACK;
	board[3][0] = WHITE;
	board[4][1] = WHITE;

	int[][] g2 = getGroup(4,0);
	assertTrue(locArrayString(g2).equals("(4, 0)"),"group 2 is wrong");
	assertTrue(!isGroupAlive(g2),"group 2 should be dead");
}


int [][] group;
int groupSize;

//TODO - remove this 
int xMin, xMax, yMin, yMax;
int groupColor;

//TODO - make a function that checks if the group stored in "group" is alive

public int[][] getGroup(int xPos, int yPos){
	groupSize = 0;
	group = new int [boardSize*boardSize][2];
	xMin = 0;
	xMax = boardSize-1;
	yMin = 0;
	yMax = boardSize-1;
	groupColor = board[xPos][yPos];
	if (groupColor != EMPTY){
		findGroupRecursively(xPos, yPos);
	}
	int[][] retVal = Arrays.copyOfRange(group, 0, groupSize);
	return retVal;
}

public void findGroupRecursively(int xPos, int yPos){
	//assume it is a valid position
		
	boolean checksPass = true;

	//check if stone at this location is proper color
	if(groupColor != board[xPos][yPos]){
		checksPass = false;
	}
	
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
		int[][] neighbors = getSurroundingLocations(xPos, yPos);//TODO - pass an array here instead
		for(int j = 0; j<neighbors.length; j++){
			int xNb = neighbors[j][0];
			int yNb = neighbors[j][1];
			findGroupRecursively(xNb, yNb); //TODO - pass an array to this instead
		}		
	}	
}
//look at existing group, saved in class variables, determine if it is alive
public boolean isGroupAlive(int[][] group){
	boolean hasLiberty = false;
	for(int i = 0; i<group.length; i++){
		int xStart = group[i][0];
		int yStart = group[i][1];
		
		int[][] sl = getSurroundingLocations(xStart, yStart);

		for(int j = 0; j < sl.length; j++){
			int x = sl[j][0];
			int y = sl[j][1];
			if(board[x][y] == EMPTY){
				hasLiberty = true;
			}
		}
	}	
	return hasLiberty;
}
///////////END GROUP FUNCTIONS//////////////////////
