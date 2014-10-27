public int boardSize = 13;  // Number of rows/columns on the board
public int boardX = 200;  // X position of the board (top-left corner)
public int boardY = 100;  // Y position of the board (top-left corner)
public int boxSize = 50;  // Number of pixels between each line on the board
public int stoneSize = (int)(0.8 * boxSize);  // Stone size as fraction of box size
public int boardLength = boxSize * (boardSize - 1);  // Length of the board in pixels
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
public boolean passedTurn = false;  // true if last turn was passed
public boolean gameOver = false;


void setup(){
	size(1000, 750);
	clearBoard();
	drawBoard();
}

void draw() {
	// draw background to clear screen
	background(240);
	drawBoard();
	drawStones();
	drawPlayerTurn();
	// draw score
	drawPassBtn();
	if (gameOver) {
		drawGameOver();
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
	fill(220, 179, 92);
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
	if (currentPlayer == BLACK){
		player = "Black";	
	}
	else {
		player = "White";	
	}
	text(player + " player's turn", playerTextX, playerTextY);	
}

void drawPassBtn() {
	// draws the pass button
	fill(64, 224, 208);
	rect(passBtnX, passBtnY, passBtnWidth, passBtnHeight);
	fill(0);
	textSize(24);
	text("PASS", passBtnX + 20, passBtnY + 30);	
}

void drawGameOver() {
	// draws the game over display
	fill(0);
	textSize(100);
	text("GAME OVER", 200, 200);
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