int boardSize = 13;  // Number of rows/columns on the board
int boardX = 200;  // X position of the board (top-left corner)
int boardY = 100;  // Y position of the board (top-left corner)
int boxSize = 50;  // Number of pixels between each line on the board
int boardLength = boxSize * (boardSize - 1);  // Length of the board in pixels
int[][] board = new int[boardSize][boardSize];  // 0 - Empty, 1 - White, 2 - Black
public static final int EMPTY = 0;
public static final int WHITE = 1;
public static final int BLACK = 2;

void setup(){
	size(1000, 750);
	background(240);
	clearBoard();
	drawBoard();
	
}

void draw(){
  ellipse(10,10,10,10);
}

void clearBoard(){
	for (int i = 0; i < boardSize; i++){
		for (int j = 0; j < boardSize; j++){
			board[i][j] = EMPTY;
		}
	}	
}

void drawBoard(){
	fill(220, 179, 92);  // board color
	strokeWeight(2);
	rect(boardX, boardY, boardLength, boardLength);
	strokeWeight(1);
	for (int i = 0; i < boardSize; i++){
		line(boardX + i * boxSize, boardY, boardX + i * boxSize, boardY + boardLength);
		line(boardX, boardY + i * boxSize, boardX + boardLength, boardY + i * boxSize);
	}
	
}


